//
//  AnimationLibrary.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-15.
//

import RealityKit

// Enum to distinguish between pose and animation files.
private enum AnimationType {
    case pose
    case animation
}

class AnimationLibrary {
    static let shared = AnimationLibrary()
    
    // Dictionary to store animation clips by key.
    private(set) var poses: [String: AnimationResource] = [:]
    private(set) var animations: [String: AnimationResource] = [:]
    
    private init() {
        Task {
            await loadAnimations()
        }
    }
    
    /// Preloads multiple animations/poses asynchronously.
    private func loadAnimations() async {
        // Mapping from key to file names for poses.
        let poseFiles: [String: String] = [
            "pose_1_anim": "pose_1_anim",  // For pose 1
            "pose_2_anim": "pose_2_anim"   // For pose 2
        ]
        // Mapping from key to file names for general animations.
        let animationFiles: [String: String] = [
            "idle": "model_head",      // For "idle", load from model_head.usdc
        ]
        
        // Load pose files.
        for (key, fileName) in poseFiles {
            await loadAnimation(for: key, fileName: fileName, type: .pose)
        }
        // Load animation files.
        for (key, fileName) in animationFiles {
            await loadAnimation(for: key, fileName: fileName, type: .animation)
        }
        if let animation = animations["idle"] {
            print("Animation loaded: \(animation)")
            let view = await AnimationView(source: animation.definition,
                                           name: "default",
                                           bindTarget: nil,
                                           blendLayer: 0,
                                           repeatMode: .none,
                                           fillMode: [],
                                           trimStart: 0.0,
                                           trimEnd: 0.2,
                                           trimDuration: nil,
                                           offset: 0,
                                           delay: 0,
                                           speed: 1.0)
            
            
            // Create an animation resource from the clip.
            let clipResource = try? await AnimationResource.generate(with: view)
            if let clipResource = clipResource {
                animations["default"] = clipResource
                print("Generated animation resource for idle: \(clipResource)")
            } else {
                print("Failed to generate animation resource for idle")
            }
        } else {
            print("No animation found for key: idle")
        }
    }
    
    /// Asynchronously loads an animation file and stores it in the appropriate dictionary.
    private func loadAnimation(for key: String, fileName: String, type: AnimationType) async {
        do {
            // Use the async initializer. Note: Ensure that your files are added to the main bundle.
            let entity = try await Entity(named: fileName)
            
            // Try to find the model entity containing the animations.
            let modelEntity: Entity
            if let found = await entity.findEntity(named: "Armature") {
                modelEntity = found
            } else if let found = await entity.findEntity(named: "Armature_001") {
                modelEntity = found
            } else if let model = entity as? ModelEntity {
                modelEntity = model
            } else {
                print("No model entity found in file: \(fileName)")
                return
            }
            
            // Retrieve available animations from the model entity.
            let animationsArray = await modelEntity.availableAnimations
            
            // Use the first available animation for simplicity.
            if let firstAnimation = animationsArray.last {
                // Optionally, repeat the animation indefinitely (duration = 0 or you can use .infinity).
                // In this example, we call repeat with a duration of 0 (no repeat) as a placeholder.
                let repeatedAnimation = await firstAnimation.repeat(duration: .infinity)
                // Save to the appropriate dictionary based on the type.
                switch type {
                case .pose:
                    poses[key] = firstAnimation
                case .animation:
                    animations[key] = repeatedAnimation
                }
                print("Loaded \(type == .pose ? "pose" : "animation"): \(key)")
            } else {
                print("No animations available in file \(fileName)")
            }
        } catch {
            print("Error loading \(type == .pose ? "pose" : "animation") \(key) from file \(fileName): \(error)")
        }
    }
    
    /// Retrieves an animation clip for a given key.
    func animation(for key: String) -> AnimationResource? {
        return animations[key]
    }
    
    /// Retrieves a pose clip for a given key.
    func pose(for key: String) -> AnimationResource? {
        return poses[key]
    }
    
    /// Optionally, add an animation to the library.
    func addAnimation(_ animation: AnimationResource, for key: String) {
        animations[key] = animation
    }
    
    /// Optionally, add a pose to the library.
    func addPose(_ pose: AnimationResource, for key: String) {
        poses[key] = pose
    }
}

