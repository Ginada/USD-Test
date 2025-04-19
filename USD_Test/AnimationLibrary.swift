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
        let repeatedAnimationFiles: [String: String] = [
            "all": "base_animations",
        ]
        let animationFiles: [String: String] = [
            "inbetween": "inbetween_animation",
        ]
        
        // Load pose files.
        for (key, fileName) in poseFiles {
            await loadAnimation(for: key, fileName: fileName, type: .pose)
        }
        // Load animation files.
        for (key, fileName) in animationFiles {
            await loadAnimation(for: key, fileName: fileName, type: .animation)
        }
        for (key, fileName) in repeatedAnimationFiles {
            await loadAnimation(for: key, fileName: fileName, type: .animation, repeated: true)
        }
        if let idle = AnimationLibrary.shared.animation(for: "all") {
            let frameRate = 25.0 // Set your animation's frame rate here
            let clip = await AnimationLibrary.shared.extractClipByFrames(
                from: idle,
                name: "default",
                startFrame: 0,
                endFrame: 10,
                frameRate: frameRate
            )
            animations["default"] = clip
            
            let clip_idle = await AnimationLibrary.shared.extractClipByFrames(
                from: idle,
                name: "idle",
                startFrame: 10,
                endFrame: 190,
                frameRate: frameRate,
                repeatMode: .repeat // <-- Use repeat mode
            )
            animations["idle"] = clip_idle
        }
                
    }

    /// Extracts a trimmed animation clip from an existing AnimationResource using frame numbers.
    /// - Parameters:
    ///   - source: The source AnimationResource.
    ///   - name: The name for the new clip.
    ///   - startFrame: Start frame number.
    ///   - endFrame: End frame number.
    ///   - frameRate: Frames per second of the animation.
    ///   - speed: Playback speed.
    /// - Returns: A new AnimationResource, or nil if generation fails.
    func extractClipByFrames(
        from source: AnimationResource,
        name: String,
        startFrame: Int,
        endFrame: Int,
        frameRate: Double,
        speed: Float = 1.0,
        repeatMode: AnimationRepeatMode = .none // <-- New parameter with default
    ) async -> AnimationResource? {
        let trimStart = Double(startFrame) / frameRate
        let trimEnd = Double(endFrame) / frameRate
        
        let view = await AnimationView(
            source: source.definition,
            name: name,
            bindTarget: nil,
            blendLayer: 0,
            repeatMode: repeatMode, // <-- Use parameter
            fillMode: [],
            trimStart: trimStart,
            trimEnd: trimEnd,
            trimDuration: nil,
            offset: 0,
            delay: 0,
            speed: speed
        )
        return try? await AnimationResource.generate(with: view)
    }
    
    /// Asynchronously loads an animation file and stores it in the appropriate dictionary.
    private func loadAnimation(for key: String, fileName: String, type: AnimationType, repeated: Bool = false) async {
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
            if let firstAnimation = animationsArray.first {
                // Optionally, repeat the animation indefinitely (duration = 0 or you can use .infinity).
                // In this example, we call repeat with a duration of 0 (no repeat) as a placeholder.
                let repeatedAnimation = await firstAnimation.repeat(duration: .infinity)
                // Save to the appropriate dictionary based on the type.
                switch type {
                case .pose:
                    poses[key] = firstAnimation
                case .animation:
                    if repeated {
                        animations[key] = repeatedAnimation
                    } else {
                        animations[key] = firstAnimation
                    }
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

