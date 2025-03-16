//
//  AnimationLibrary.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-15.
//

import RealityKit
import Foundation

class AnimationLibrary {
    static let shared = AnimationLibrary()
    
    // Dictionary to store animation clips by key.
    private(set) var animations: [String: AnimationResource] = [:]
    
    private init() {
        Task {
            await loadAnimations()
        }
    }
    
    /// Preloads animations asynchronously.
    private func loadAnimations() async {
        do {
            // Locate the USD scene file in the bundle.
            guard let url = Bundle.main.url(forResource: "model_head",
                                            withExtension: "usdc",
                                            subdirectory: "Art.scnassets/USD") else {
                fatalError("Unable to locate the face model in the bundle")
            }
            // Use the async initializer instead of a static load method.
            let faceEntity = try await Entity(contentsOf: url)
            
            // Find the ModelEntity named "Armature".
            guard let modelEntity = faceEntity.findEntity(named: "Armature") as? ModelEntity else {
                fatalError("Face Armature not found")
            }
            
            // Await the asynchronous property to obtain the available animations.
            let animationsArray = await modelEntity.availableAnimations
            guard let idleAnim = animationsArray.first else {
                print("No animations found in the model entity.")
                return
            }
            
            // Await the asynchronous repeat operation.
            let repeatedAnimation = await idleAnim.repeat(duration: .infinity)
            animations["idle"] = repeatedAnimation
            
            // Optionally, to play the animation immediately:
            // modelEntity.playAnimation(repeatedAnimation,
            //                           transitionDuration: 1.25,
            //                           startsPaused: false)
        } catch {
            print("Error loading model entity: \(error)")
        }
    }
    
    /// Retrieves an animation clip for a given key.
    func animation(for key: String) -> AnimationResource? {
        return animations[key]
    }
    
    /// Optionally, add an animation to the library.
    func addAnimation(_ animation: AnimationResource, for key: String) {
        animations[key] = animation
    }
}
