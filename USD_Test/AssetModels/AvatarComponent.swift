//
//  AvatarComponent.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-22.
//
import SwiftUI
import RealityKit
import Combine

class AvatarComponent: ObservableObject {
    var armature: [ModelEntity] = []
    let animationLibrary = AnimationLibrary.shared

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
    
    
    func updateShapeAnimated(with shapes: [(shape: FaceShape, weight: CGFloat)], duration: TimeInterval = 0.5) {
        armature.forEach { node in
            // Retrieve the blend shape component.
            guard let blendShapeComponent = node.components[BlendShapeWeightsComponent.self] else {
                return
            }
            
            // Get the current blend shape data from the first weight set.
            let currentData = blendShapeComponent.weightSet[0]
            
            // Convert current data into a BlendShapeWeights instance.
            let fromWeights = BlendShapeWeights(currentData.weights)
            var toWeights = fromWeights
            
            // Retrieve weight names (if needed by the animation).
            let weightNames = blendShapeComponent.weightSet.first?.weightNames ?? []

            // Loop through each (FaceShape, weight) pair and update the corresponding blend shape index.
            for (faceShape, weight) in shapes {
                // Determine which blend shape index to use based on the node name.
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
                
                // Verify the index exists within the weight array.
                if let index = blendIndex, fromWeights.indices.contains(index) {
                    // Update the target weight.
                    toWeights[index] = Float(weight)
                }
            }
            
            // Create the FromToByAnimation with the new weights.
            let animationDefinition = FromToByAnimation<BlendShapeWeights>(
                weightNames: weightNames,
                from: fromWeights,
                to: toWeights,
                duration: duration,
                timing: .linear,
                isAdditive: false,
                bindTarget: .blendShapeWeights
            )
            
            // Optionally wrap the animation in an AnimationView.
            let animationViewDefinition = AnimationView(source: animationDefinition, delay: 0, speed: 1.0)
            
            // Generate an AnimationResource and play it.
            do {
                let animationResource = try AnimationResource.generate(with: animationViewDefinition)
                node.playAnimation(animationResource)
            } catch {
                print("Error generating blend shape animation for node \(node.name): \(error)")
            }
        }
    }
    
    init(armature: [ModelEntity]) {
        self.armature = armature
    }
    
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
//            
//            // Optionally, subscribe to the playback completion event on one of the entities.
//            if let firstEntity = armature.first, let scene = firstEntity.scene {
//                var animationSubscription: Cancellable?
//                animationSubscription = scene.subscribe(
//                    to: AnimationEvents.PlaybackCompleted.self,
//                    on: firstEntity
//                ) { [weak self] event in
//                    // Once the animation completes, stop any active animations.
//                    self?.stopAnimations()
//                    animationSubscription?.cancel()
//                }
//            }
        } else {
            print("Default pose animation clip not found in the library.")
        }
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
