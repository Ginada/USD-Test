//
//  AvatarComponent.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-22.
//
import SwiftUI
import RealityKit
import Combine

protocol AnimatableAvatar {
    
    func playAnimation(name: String, transitionDuration: TimeInterval)
    func startPingPongShapeAnimation(with shapes: [(shape: FaceShape, weight: CGFloat)], animationDuration: TimeInterval, pauseAtTarget: TimeInterval, loopPause: TimeInterval)
    func updateShapeAnimated(with shapes: [(shape: FaceShape, weight: CGFloat)], duration: TimeInterval, reverse: Bool, reversePause: TimeInterval)
}


class AvatarComponent: ObservableObject, AnimatableAvatar {
    
    var armature: [ModelEntity] = []
    let animationLibrary = AnimationLibrary.shared
    //private var pingPongOriginalShapes: [(shape: FaceShape, weight: CGFloat)]?
    //private var pingPongIsForward = true
    //private var pingPongIsPaused = false
    private var pingPongSubscription: Cancellable?
    private var pingPongIsActive = false
    
    
    
    /// Loads a ModelEntity (armature) from a USD file and applies the given material and orientation.
    init(resourceName: String,
         targetEntityName: String = "Armature",
         material: RealityKit.Material? = nil,
         orientation: simd_quatf? = nil) {
        guard let rootEntity = try? Entity.load(named: resourceName) else {
            return
        }
        guard let armatureEntity = rootEntity.findEntity(named: targetEntityName) as? ModelEntity else {
            fatalError("Target entity \(targetEntityName) not found in \(resourceName)")
        }
        if let material = material {
            armatureEntity.setMaterial(material)
        }
        if let orientation = orientation {
            armatureEntity.orientation = orientation
        }
        self.armature.append(armatureEntity)
        
    }
    
    init(resourceNames: [String],
         targetEntityName: String = "Armature",
         material: RealityKit.Material? = nil,
         orientation: simd_quatf? = nil) {
        
        for resource in resourceNames {
            // Attempt to load the root entity for the current resource.
            guard let rootEntity = try? Entity.load(named: resource) else {
                // Skip this resource if it fails to load.
                continue
            }
            
            // Look for the target entity within the root entity.
            guard let armatureEntity = rootEntity.findEntity(named: targetEntityName) as? ModelEntity else {
                fatalError("Target entity \(targetEntityName) not found in \(resource)")
            }
            
            // Optionally apply a material.
            if let material = material {
                armatureEntity.setMaterial(material)
            }
            
            // Optionally apply an orientation.
            if let orientation = orientation {
                armatureEntity.orientation = orientation
            }
            
            // Add the successfully loaded armature entity to the array.
            self.armature.append(armatureEntity)
        }
    }
    
    init() {}

    init(armature: [ModelEntity]) {
        self.armature = armature
    }
    
    func loadModel(_ assetStyle: any AssetStyle) {
        
    }
    
    func updateShape(with shape: FaceShape, weight: CGFloat) {
        armature.forEach {node in
            guard var blendShape = node.components[BlendShapeWeightsComponent.self] else { return }
            var currentWeights = blendShape.weightSet[0].weights
            
            // Determine the blendshape index based on the node's name.
            var blendIndex: Int?
            node.children.forEach { child in
                switch child.name {
                case "Eyebrows":
                    blendIndex = shape.browIndex
                case "Lashes_upper", "Lashes_lower":
                    blendIndex = shape.eyelashesIndex
                default:
                    if blendIndex == nil {
                        blendIndex = shape.rawValue
                    }
                }
            }
            
            guard let blendIndex = blendIndex, currentWeights.indices.contains(blendIndex) else { return }
            currentWeights[blendIndex] = Float(weight)
            
            // Update the blendshape component.
            blendShape.weightSet[0].weights = currentWeights
            node.components.set(blendShape)
        }
    }
    
    func updateFaceShape(settings: [FaceShape: Double]) {
        guard let headArmature = armature.first else {
            fatalError("Head Armature not found")
        }
        
        for setting in settings {
            updateShape(with: setting.key, weight: setting.value)
        }
    }
    
//    private func playPingPongStep(
//        shapes: [(shape: FaceShape, weight: CGFloat)],
//        originalShapes: [(shape: FaceShape, weight: CGFloat)],
//        duration: TimeInterval,
//        pauseDuration: TimeInterval
//    ) {
//        let targetShapes = pingPongIsForward ? shapes : originalShapes
//        pingPongIsForward.toggle()
//        
//        // Play the animation
//        updateShapeAnimated(with: targetShapes, duration: duration)
//        
//        // Subscribe to animation completion on the first armature node
//        if let node = armature.first, let scene = node.scene {
//            pingPongSubscription?.cancel()
//            pingPongSubscription = scene.subscribe(
//                to: AnimationEvents.PlaybackCompleted.self,
//                on: node
//            ) { [weak self] _ in
//                guard let self = self else { return }
//                // Wait for pauseDuration, then play the next step
//                DispatchQueue.main.asyncAfter(deadline: .now() + pauseDuration) {
//                    self.playPingPongStep(
//                        shapes: shapes,
//                        originalShapes: originalShapes,
//                        duration: duration,
//                        pauseDuration: pauseDuration
//                    )
//                }
//            }
//        }
//    }
    
    func stopLoopingShapeAnimation() {
       pingPongIsActive = false
        pingPongSubscription?.cancel()
        pingPongSubscription = nil
    }
    
    func updateShapeAnimated(
        with shapes: [(shape: FaceShape, weight: CGFloat)],
        duration: TimeInterval = 0.5,
        reverse: Bool = false,
        reversePause: TimeInterval = 0.0
    ) {
        // Save original weights if reverse is requested
        var originalShapes: [(shape: FaceShape, weight: CGFloat)] = []
        if reverse {
            armature.forEach { node in
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
        armature.forEach { node in
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
                node.playAnimation(animationResource)
            } catch {
                print("Error generating blend shape animation for node \(node.name): \(error)")
            }
        }
        
        // If reverse is requested, subscribe to completion and animate back
        if reverse, let node = armature.first, let scene = node.scene {
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
    
//    private func pingPongAnimateForward(
//        shapes: [(shape: FaceShape, weight: CGFloat)],
//        originalShapes: [(shape: FaceShape, weight: CGFloat)],
//        animationDuration: TimeInterval,
//        pauseAtTarget: TimeInterval,
//        loopPause: TimeInterval
//    ) {
//        guard pingPongIsActive else { return }
//        updateShapeAnimated(with: shapes, duration: animationDuration)
//        
//        // Subscribe to animation completion
//        if let node = armature.first, let scene = node.scene {
//            pingPongSubscription?.cancel()
//            pingPongSubscription = scene.subscribe(
//                to: AnimationEvents.PlaybackCompleted.self,
//                on: node
//            ) { [weak self] _ in
//                guard let self = self, self.pingPongIsActive else { return }
//                self.pingPongSubscription?.cancel()
//                // Pause at target
//                DispatchQueue.main.asyncAfter(deadline: .now() + pauseAtTarget) {
//                    self.pingPongAnimateBackward(
//                        shapes: shapes,
//                        originalShapes: originalShapes,
//                        animationDuration: animationDuration, pauseAtTarget: pauseAtTarget,
//                        loopPause: loopPause
//                    )
//                }
//            }
//        }
//    }
    
//    private func pingPongAnimateBackward(
//        shapes: [(shape: FaceShape, weight: CGFloat)],
//        originalShapes: [(shape: FaceShape, weight: CGFloat)],
//        animationDuration: TimeInterval,
//        pauseAtTarget: TimeInterval, // <-- Add this parameter
//        loopPause: TimeInterval
//    ) {
//        guard pingPongIsActive else { return }
//        updateShapeAnimated(with: originalShapes, duration: animationDuration)
//        if let node = armature.first, let scene = node.scene {
//            pingPongSubscription?.cancel()
//            pingPongSubscription = scene.subscribe(
//                to: AnimationEvents.PlaybackCompleted.self,
//                on: node
//            ) { [weak self] _ in
//                guard let self = self, self.pingPongIsActive else { return }
//                self.pingPongSubscription?.cancel()
//                DispatchQueue.main.asyncAfter(deadline: .now() + loopPause) {
//                    self.pingPongAnimateForward(
//                        shapes: shapes,
//                        originalShapes: originalShapes,
//                        animationDuration: animationDuration,
//                        pauseAtTarget: pauseAtTarget, // <-- Pass it here
//                        loopPause: loopPause
//                    )
//                }
//            }
//        }
//    }
    
    /// Plays an animation with the given name.
    func playAnimation(name: String, transitionDuration: TimeInterval = 0.3) {
        if let clip = animationLibrary.animation(for: name) {
            armature.forEach { armatur in
                armatur.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
            }
        }
    }
    
    func stopAnimations() {
        if let defaultPoseClip = animationLibrary.animation(for: "default") {
            armature.forEach { entity in
                entity.playAnimation(defaultPoseClip, transitionDuration: 0.3, startsPaused: false)
            }
        } else {
            print("Default pose animation clip not found in the library.")
        }
        stopLoopingShapeAnimation()
    }
    
    func setPose(name: String, transitionDuration: TimeInterval = 0.3) {
        if let clip = animationLibrary.pose(for: name) {
            armature.forEach { armatur in
                armatur.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
            }
            updateShapeAnimated(with: [(shape: .smile, weight: 1.0), (shape: .blink, weight: 0.5)], duration: 0.3)
        }
    }
    
    func removeAll() {
        
        for child in armature {
            child.removeFromParent()
        }
        // Clear the armature array as well.
        armature.removeAll()
    }
    
    /// Adjusts the base color according to the makeup material settings.
    static func adjustedColor(from makeupMat: MakeupMat) -> UIColor {
        var color = UIColor(hex: makeupMat.color, alpha: 1)
        if !(color.isLight() ?? false) {
            color = color.lighter(by: CGFloat(makeupMat.finish.lighterPercentage))
        }
        return color
    }
    
    static func extractRoughness(from makeupMat: MakeupMat, type: MakeupType) -> (Float, String?) {
        let roughnessData = makeupMat.finish.rougness(type: type)
        var roughnessValue: Float = 1.0
        var roughnessTexture: String? = nil
        
        if let roughnessColor = roughnessData as? UIColor {
            roughnessValue = Float(roughnessColor.blueValue)
        } else if let textureName = roughnessData as? String {
            roughnessTexture = textureName
        }
        
        return (roughnessValue, roughnessTexture)
    }
}
