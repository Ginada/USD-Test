//
//  FaceModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-14.
//

import Foundation
import RealityKit
import SwiftUI
import Combine

class FaceModel: BaseModel, ObservableObject {
    private var pingPongIsActive = false
    private var pingPongSubscription: Cancellable?
    // MARK: - Properties
    var allMakeupNodes: [MakeupType: [ModelEntity]] = [:]
    @Published var currentMakeupNodes: [MakeupType: [ModelEntity]] = [:]
    var allNodes: [ModelEntity] {
        allMakeupNodes.values.flatMap { $0 }
    }
    var animationModel: ModelEntity?
    /// The base model used to create makeup layer clones.
    var baseLayer: ModelEntity!
    
    // MARK: - Initialization
    override init() {
        super.init()
        // Load the base face model from your USDZ file.
        // (Ensure that loadModelEntity(...) is implemented in BaseModel or elsewhere.)
        let baseFaceArmature = loadModelEntity(named: "Armature",
                                               fromResource: "model_makeup")
        // Adjust orientation as needed.
        baseFaceArmature.orientation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
        self.baseLayer = baseFaceArmature
        self.animationModel = loadModelEntity(named: "Armature",
                                               fromResource: "model_lashes_upper")
        
        // Initialize default makeup layers.
        initLayers()
    }
    
    // MARK: - Makeup Layer Management
    
    /// Hides (removes) all active makeup layers.
    override func removeAll() {
        for (_, entities) in currentMakeupNodes {
            entities.forEach { $0.isEnabled = false }
        }
        updateFaceShape(settings: [FaceShape.smile: 0, FaceShape.blink: 0, FaceShape.jawOpen: 0, FaceShape.pout: 0, FaceShape.frown: 0])
    }
    
    /// Hides all active layers for a given makeup type.
    func removeAllFor(type: MakeupType) {
        if let entities = currentMakeupNodes[type] {
            entities.forEach { $0.isEnabled = false }
        }
    }
    
    /// For the paint type, hide all layers except the first.
    func removeAllForPaint() {
        let type = MakeupType.paint
        if let entities = currentMakeupNodes[type], entities.count > 1 {
            for entity in entities[1..<entities.count] {
                entity.isEnabled = false
            }
        }
    }
    
    func updateShape(with shape: FaceShape, weight: CGFloat) {
        var allShapeNodes = allNodes
        allShapeNodes.append(baseLayer)
        allShapeNodes.forEach {node in
            guard var blendShape = node.components[BlendShapeWeightsComponent.self] else { return }
            var currentWeights = blendShape.weightSet[0].weights
            
            // Determine the blendshape index based on the node's name.
            let blendIndex: Int
            switch node.name {
            case "Eyebrows":
                guard let index = shape.browIndex else { return }
                blendIndex = index
            case "Lashes_upper", "Lashes_lower":
                guard let index = shape.eyelashesIndex else { return }
                blendIndex = index
            default:
                blendIndex = shape.rawValue
            }
            
            guard currentWeights.indices.contains(blendIndex) else { return }
            currentWeights[blendIndex] = Float(weight)
            
            // Update the blendshape component.
            blendShape.weightSet[0].weights = currentWeights
            node.components.set(blendShape)
        }
    }
    
    /// Replaces the current makeup with the provided makeup layers.
    func replaceWith(layers: [MakeupLayer], completion: @escaping () -> ()) {
        removeAll()
        for (index, layer) in layers.enumerated() {
            let delay = DispatchTimeInterval.seconds(index / 3)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.selectedMakeupWith(layer: layer)
                if index == layers.count - 1 {
                    completion()
                }
            }
        }
    }
    
    /// Removes a makeup layer for a given type at a specific order.
    func removeMakeup(type: MakeupType, order: Int) {
        switch type {
        case .eyeshadow, .lipliner, .lips, .foundation, .rouge,
             .eyeliner, .freckles, .glitter, .sculptShadow, .sculptHighlight, .paint:
            guard var currentLayers = currentMakeupNodes[type],
                  currentLayers.count > order else { return }
            
            let entity = currentLayers[order]
            // Reset material (here we simply assign a default transparent material).
            if var modelComp = entity.components[ModelComponent.self] {
                modelComp.materials = [MaterialManager.transparentMaterial()]
                entity.components.set(modelComp)
            }
            entity.isEnabled = false
            currentMakeupNodes[type]?.remove(at: order)
            
            // Update draw order for remaining layers.
            for (index, entity) in (currentMakeupNodes[type] ?? []).enumerated() {
                let sortGroup = ModelSortGroup()
                let drawOrder = Int32(type.renderingOrder + index)
                let sortComponent = ModelSortGroupComponent(group: sortGroup, order: drawOrder)
                entity.components.set(sortComponent)
            }
        default:
            break
        }
    }
    
    /// Updates the transparency of a makeup layer.
    func transparencyUpdate(layer: MakeupLayer) {
        var transparency = layer.transparency ?? 1.0
        if layer.material?.isClear ?? false {
            transparency /= 2
        }
        switch layer.asset.type {
        case .eyeshadow, .foundation, .lips, .lipliner,
             .eyeliner, .glitter, .rouge, .sculptShadow, .sculptHighlight, .freckles, .paint:
            guard let currentLayers = currentMakeupNodes[layer.asset.type],
                  currentLayers.count > layer.order,
                  let mat = layer.material else { return }
            
            let entity = currentLayers[layer.order]
            var color = UIColor(hex: mat.color, alpha: 1)
            if !(color.isLight() ?? false) {
                color = color.lighter(by: CGFloat(mat.finish.lighterPercentage))
            }
            let newMaterial = MaterialManager.createPBRMaterial(
                color: color,
                normal: mat.finish.normal(type: layer.asset.type, dimples: false),
                opacity: transparency,
                mask: layer.maskImage
            )
            entity.setMaterial(newMaterial)
        default:
            return
        }
    }
    
    func updateFaceShape(settings: [FaceShape: Double]) {
        
        for setting in settings {
            updateShape(with: setting.key, weight: setting.value)
        }
    }
    
    /// Adds a new makeup layer for the specified type.
    private func addMakeupLayer(_ type: MakeupType) {
        // Clone the baseLayer as the new makeup layer.
        let newClone = baseLayer.clone(recursive: true)
        newClone.name = "\(type)_layer_\(UUID().uuidString.prefix(6))"
  
        // Assign a default transparent material.
        let transparent = MaterialManager.transparentMaterial()
        newClone.setMaterial(transparent)
        newClone.transform = baseLayer.transform
//        if var baseBlendShape = baseLayer.components[BlendShapeWeightsComponent.self],
//              var newBlendShape = newClone.components[BlendShapeWeightsComponent.self] {
//               // Copy all weights from baseLayer to newClone
//               for i in 0..<baseBlendShape.weightSet.count {
//                   newBlendShape.weightSet[i].weights = baseBlendShape.weightSet[i].weights
//               }
//               newClone.components.set(newBlendShape)
//           }
        
        if allMakeupNodes[type] == nil {
            allMakeupNodes[type] = []
            currentMakeupNodes[type] = []
        }
        allMakeupNodes[type]?.append(newClone)
        currentMakeupNodes[type]?.append(newClone)
        
        parent.addChild(newClone)
    }
    
    /// Applies makeup settings (color, opacity, textures, etc.) to a makeup layer.
    func selectedMakeupWith(layer: MakeupLayer) {
        guard let makeupMat = layer.material else { return }
        let type = layer.asset.type
        
        // Prepare adjusted color.
        let adjustedColor = AvatarComponent.adjustedColor(from: makeupMat)
        let mask = layer.maskImage
        let normalMapName = makeupMat.finish.normal(type: type, dimples: false)
        
        // Retrieve or create a makeup entity for this layer.
        let makeupEntity = getOrCreateMakeupEntity(for: layer, type: type)
        makeupEntity.isEnabled = true
        
        // Calculate material parameters.
        let opacity: Float = (makeupMat.isClear ?? false)
        ? ((layer.transparency ?? 1.0) / 2)
        : (layer.transparency ?? 0.7)
        
        let (roughnessValue, roughnessTexture) = AvatarComponent.extractRoughness(from: makeupMat, type: type)
        let metalnessValue: Float = Float(makeupMat.finish.metalness(type: type).blueValue)
        
        // Create and assign the new material.
        let newMaterial = MaterialManager.makeupMaterial(
            color: adjustedColor,
            normal: normalMapName,
            opacity: opacity,
            mask: mask,
            roughness: roughnessValue,
            roughnessTexture: roughnessTexture,
            metalness: metalnessValue
        )
        makeupEntity.setMaterial(newMaterial)
        
        // Update the sort group for transparent rendering.
        let sortGroup = ModelSortGroup()
        let drawOrder = Int32(type.renderingOrder + layer.order)
        let sortComponent = ModelSortGroupComponent(group: sortGroup, order: drawOrder)
        makeupEntity.components.set(sortComponent)
        
        // Update the active node list.
        currentMakeupNodes[type]?[layer.order] = makeupEntity
    }

    /// Retrieves an existing makeup entity or creates one if needed.
    private func getOrCreateMakeupEntity(for layer: MakeupLayer, type: MakeupType) -> ModelEntity {
        // Ensure a layer exists for the given order.
        if layer.order + 1 > (allMakeupNodes[type]?.count ?? 0) {
            addMakeupLayer(type)
        }
        
        guard var currentNodes = currentMakeupNodes[type] else {
            fatalError("No makeup nodes available for type \(type)")
        }
        
        // Use an existing entity if available.
        if layer.order < currentNodes.count {
            return currentNodes[layer.order]
        }
        
        // Otherwise, search for an unused entity in the pool.
        if let newEntity = allMakeupNodes[type]?.first(where: { !currentNodes.contains($0) }) {
            currentMakeupNodes[type]?.append(newEntity)
            return newEntity
        }
        
        fatalError("Unable to retrieve or create a makeup entity for type \(type)")
    }
    
    /// Initializes makeup layers based on a given asset category.
    func initMakeupLayers(category: AssetCategory) {
        switch category {
        case .eyeshadow:
            if currentMakeupNodes[.eyeshadow] == nil {
                addMakeupLayer(.eyeshadow)
            }
        case .lips:
            if currentMakeupNodes[.lips] == nil {
                addMakeupLayer(.lips)
            }
        case .contouring:
            if currentMakeupNodes[.sculptShadow] == nil {
                addMakeupLayer(.sculptShadow)
            }
            if currentMakeupNodes[.sculptHighlight] == nil {
                addMakeupLayer(.sculptHighlight)
            }
            if currentMakeupNodes[.rouge] == nil {
                addMakeupLayer(.rouge)
            }
        default:
            break
        }
    }
    
    /// Initializes a default set of makeup layers.
    func initLayers() {
        addMakeupLayer(.eyeshadow)
        addMakeupLayer(.lips)
        addMakeupLayer(.sculptShadow)
        addMakeupLayer(.sculptHighlight)
        addMakeupLayer(.rouge)
        removeAll()
    }
    
    func playAnimation(name: String, transitionDuration: TimeInterval = 0.3) {
        if let clip = AnimationLibrary.shared.animation(for: name) {
            currentMakeupNodes.forEach { type, makeups in
                makeups.forEach { makeup in
                    makeup.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
                }
            }
        }
    }
    
    func setPose(name: String, transitionDuration: TimeInterval = 0.3) {
        if let clip = AnimationLibrary.shared.pose(for: name) {
            currentMakeupNodes.forEach { type, makeups in
                makeups.forEach { makeup in
                    makeup.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
                }
            }
        }
    }
    
    func stopAnimations() {
        if let defaultPoseClip = AnimationLibrary.shared.animation(for: "default") {
            allNodes.forEach { entity in
                entity.playAnimation(defaultPoseClip, transitionDuration: 0.3, startsPaused: false)
            }
        } else {
            print("Default pose animation clip not found in the library.")
        }
        stopLoopingShapeAnimation()
    }
}

extension FaceModel: AnimatableAvatar {
    //animation
    
    func startPingPongShapeAnimation(
        with shapes: [(shape: FaceShape, weight: CGFloat)],
        animationDuration: TimeInterval,
        pauseAtTarget: TimeInterval,
        loopPause: TimeInterval
    ) {
        stopLoopingShapeAnimation()
        pingPongIsActive = true
        
        func pingPongStep() {
            guard self.pingPongIsActive else { return }
            self.updateShapeAnimated(
                with: shapes,
                duration: animationDuration,
                reverse: true,
                reversePause: pauseAtTarget
            )
            // Schedule next ping-pong after forward+pause+reverse+loopPause
            let totalDelay = animationDuration + pauseAtTarget + animationDuration + loopPause
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
                pingPongStep()
            }
        }
        
        pingPongStep()
    }
    
    func updateShapeAnimated(
        with shapes: [(shape: FaceShape, weight: CGFloat)],
        duration: TimeInterval = 0.5,
        reverse: Bool = false,
        reversePause: TimeInterval = 0.0
    ) {
        var animationNodes = allNodes
        animationNodes.append(animationModel!)
        // Save original weights if reverse is requested
        var originalShapes: [(shape: FaceShape, weight: CGFloat)] = []
        if reverse {
            animationNodes.forEach { node in
                guard let blendShapeComponent = node.components[BlendShapeWeightsComponent.self] else { return }
                for (faceShape, _) in shapes {
                    var blendIndex: Int?
                    node.children.forEach { child in
                        switch child.name {
                        case "Eyebrows":
                            blendIndex = faceShape.browIndex
                        case "Lashes_upper", "Lashes_lower":
                            blendIndex = faceShape.eyelashesIndex
                        default:
                            if blendIndex == nil {
                                blendIndex = faceShape.rawValue
                            }
                        }
                    }
                    if let blendIndex = blendIndex,
                       blendShapeComponent.weightSet[0].weights.indices.contains(blendIndex) {
                        let currentWeight = CGFloat(blendShapeComponent.weightSet[0].weights[blendIndex])
                        originalShapes.append((shape: faceShape, weight: currentWeight))
                    }
                }
            }
        }
        
        // Animate to target
        animationNodes.forEach { node in
            // Retrieve the blend shape component.
            guard let blendShapeComponent = node.components[BlendShapeWeightsComponent.self] else {
                return
            }
            let currentData = blendShapeComponent.weightSet[0]
            let fromWeights = BlendShapeWeights(currentData.weights)
            var toWeights = fromWeights
            let weightNames = blendShapeComponent.weightSet.first?.weightNames ?? []
            for (faceShape, weight) in shapes {
                var blendIndex: Int?
                node.children.forEach { child in
                    switch child.name {
                    case "Eyebrows":
                        blendIndex = faceShape.browIndex
                    case "Lashes_upper", "Lashes_lower":
                        blendIndex = faceShape.eyelashesIndex
                    default:
                        if blendIndex == nil {
                            blendIndex = faceShape.rawValue
                        }
                    }
                }
                if let index = blendIndex, fromWeights.indices.contains(index) {
                    toWeights[index] = Float(weight)
                }
            }
            let animationDefinition = FromToByAnimation<BlendShapeWeights>(
                weightNames: weightNames,
                from: fromWeights,
                to: toWeights,
                duration: duration,
                timing: .linear,
                isAdditive: false,
                bindTarget: .blendShapeWeights
            )
            let animationViewDefinition = AnimationView(source: animationDefinition, delay: 0, speed: 1.0)
            do {
                let animationResource = try AnimationResource.generate(with: animationViewDefinition)
                print("Animation resource:", animationResource)
                print("Is named animation:", animationResource.name)
                node.playAnimation(animationResource)
            } catch {
                print("Error generating blend shape animation for node \(node.name): \(error)")
            }
        }
        
        // If reverse is requested, subscribe to completion and animate back
        if reverse, let node = animationModel, let scene = node.scene {
            var subscription: Cancellable?
            subscription = scene.subscribe(
                to: AnimationEvents.PlaybackCompleted.self,
                on: node
            ) { [weak self] _ in
                subscription?.cancel()
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + reversePause) {
                    self.updateShapeAnimated(with: originalShapes, duration: duration)
                }
            }
        }
    }
    
    func stopLoopingShapeAnimation() {
       pingPongIsActive = false
//        pingPongTimer?.invalidate()
//        pingPongTimer = nil
//        loopingAnimationTimer?.invalidate()
//        loopingAnimationTimer = nil
//        pingPongSubscription?.cancel()
//        pingPongSubscription = nil
    }
    
}
