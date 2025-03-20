//
//  LashesModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-16.
//

import RealityKit
import Foundation

class LashesModel: ObservableObject {
    
    var lashesArmature: ModelEntity
    
    init() {
        // Load the brow model.
        lashesArmature = LashesModel.createModel()
       
    }
    
    static func createModel() -> ModelEntity {
        guard let url = Bundle.main.url(forResource: "model_lashes", withExtension: "usdc", subdirectory: "Art.scnassets/USD") else {
            fatalError("Unable to locate the head model in the bundle")
        }
        
        // Load the head entity.
        let entity = try! Entity.load(contentsOf: url)
        
        // Extract the "Armature" ModelEntity from the head entity.
        guard let armature = entity.findEntity(named: "Armature") as? ModelEntity else {
            fatalError("Head Armature not found")
        }
        
        // Create and apply the PBR material.
        let pbrMaterial = MaterialManager.createPBRMaterial(texture: "lashes_1", normal: nil, doubleSided: true)
        
        armature.setMaterial(pbrMaterial)
        armature.orientation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
        
        return armature
    }
    
    func playAnimation(transitionDuration: TimeInterval = 0.3) {
        if let clip = AnimationLibrary.shared.animation(for: "idle") {
            lashesArmature.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
        }
    }
}
