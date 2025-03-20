//
//  EyesModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-16.
//

import RealityKit
import Foundation

class EyesModel: ObservableObject {
    
    var eyesOuterArmature: ModelEntity
    var eyesInnerArmature: ModelEntity
    
    init() {
        // Load the brow model.
        let pbrMaterial = MaterialManager.createPBRMaterial(texture: "Eyes_BaseColor_amber", normal: nil)
        let transparentMaterial = MaterialManager.transparentMaterial()
        eyesOuterArmature = EyesModel.createModel(name: "eyes_outer_model", material: transparentMaterial)
        eyesInnerArmature = EyesModel.createModel(name: "eyes_inner_model", material: pbrMaterial)
    }
    
    static func createModel(name: String, material: Material) -> ModelEntity {
        guard let url = Bundle.main.url(forResource: name, withExtension: "usdc", subdirectory: "Art.scnassets/USD") else {
            fatalError("Unable to locate the head model in the bundle")
        }
        
        // Load the head entity.
        let entity = try! Entity.load(contentsOf: url)
        
        // Extract the "Armature" ModelEntity from the head entity.
        guard let armature = entity.findEntity(named: "Armature") as? ModelEntity else {
            fatalError("Head Armature not found")
        }
        
        // Create and apply the PBR material.
        
        
        armature.setMaterial(material)
        armature.orientation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
        
        // Adjust blendshape weights on the head armature.
//        if var headBlendShape = headArmature.components[BlendShapeWeightsComponent.self] {
//            var currentWeights = headBlendShape.weightSet[0].weights
//            if currentWeights.count >= 4 {
//                currentWeights[0] = 0.8
//                currentWeights[1] = 0.8
//                currentWeights[2] = 0.8
//                currentWeights[3] = 0.8
//            }
//            if currentWeights.count > 20 { currentWeights[20] = 0.8 }
//            if currentWeights.count > 29 { currentWeights[29] = 0.8 }
//            if currentWeights.count > 32 { currentWeights[32] = 0.8 }
//            headBlendShape.weightSet[0].weights = currentWeights
//            headArmature.components.set(headBlendShape)
//        }
        
        // Optionally, play the first available animation.
//        if let animationResource = headArmature.availableAnimations.first {
//            let repeatedAnimation = animationResource.repeat()
//            headArmature.playAnimation(repeatedAnimation, transitionDuration: 0.2, startsPaused: false)
//        } else {
//            print("No animation found on headArmature")
//        }
        
        return armature
    }
    
    func playAnimation(transitionDuration: TimeInterval = 0.3) {
        if let clip = AnimationLibrary.shared.animation(for: "idle") {
            eyesOuterArmature.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
            eyesInnerArmature.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
        }
    }
}

