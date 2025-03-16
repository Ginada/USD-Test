//
//  HeadModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-15.
//

import RealityKit
import Foundation

class HeadModel: ObservableObject {
    let headArmature: ModelEntity
    
    init() {
        self.headArmature = HeadModel.createModel()
    }
    /// Loads the head model from the bundle, sets it up, and returns the head Armature ModelEntity.
    static func createModel() -> ModelEntity {
        // Locate the head model file.
        guard let headURL = Bundle.main.url(forResource: "headModel_anim", withExtension: "usdc", subdirectory: "Art.scnassets/USD") else {
            fatalError("Unable to locate the head model in the bundle")
        }
        
        // Load the head entity.
        let headEntity = try! Entity.load(contentsOf: headURL)
        
        // Extract the "Armature" ModelEntity from the head entity.
        guard let headArmature = headEntity.findEntity(named: "Armature") as? ModelEntity else {
            fatalError("Head Armature not found")
        }
        
        // Create and apply the PBR material.
        let pbrMaterial = MaterialManager.createPBRMaterial(texture: "Head_medium", normal: "Head_Normal")
        
        headArmature.setMaterial(pbrMaterial)
        
        // Adjust blendshape weights on the head armature.
        if var headBlendShape = headArmature.components[BlendShapeWeightsComponent.self] {
            var currentWeights = headBlendShape.weightSet[0].weights
            if currentWeights.count >= 4 {
                currentWeights[0] = 0.8
                currentWeights[1] = 0.8
                currentWeights[2] = 0.8
                currentWeights[3] = 0.8
            }
            if currentWeights.count > 20 { currentWeights[20] = 0.8 }
            if currentWeights.count > 29 { currentWeights[29] = 0.8 }
            if currentWeights.count > 32 { currentWeights[32] = 0.8 }
            headBlendShape.weightSet[0].weights = currentWeights
            headArmature.components.set(headBlendShape)
        }
        
        // Optionally, play the first available animation.
//        if let animationResource = headArmature.availableAnimations.first {
//            let repeatedAnimation = animationResource.repeat()
//            headArmature.playAnimation(repeatedAnimation, transitionDuration: 0.2, startsPaused: false)
//        } else {
//            print("No animation found on headArmature")
//        }
        
        return headArmature
    }
    
    func playAnimation(transitionDuration: TimeInterval = 0.3) {
            if let clip = AnimationLibrary.shared.animation(for: "idle") {
                headArmature.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
            }
        }
}
