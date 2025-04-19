//
//  HeadModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-15.
//

import RealityKit
import Foundation

class HeadModel: AvatarComponent {
    
    override init() {
        let material = MaterialManager.createPBRMaterial(texture: "Head_medium", normal: "Head_Normal", roughnessTexture: "Head_Roughness")
        //let material = MaterialManager.transparentMaterial()
        super.init(resourceName: "model_head",
                       targetEntityName: "Armature",
                       material: material,
                       orientation: simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0)))
        
            
        }
    
    /// Loads the head model from the bundle, sets it up, and returns the head Armature ModelEntity.
    static func createModel() -> ModelEntity {
        // Locate the head model file.
    
        // Load the head entity.
        let headEntity = try! Entity.load(named: "model_head")
        
        // Extract the "Armature" ModelEntity from the head entity.
        guard let headArmature = headEntity.findEntity(named: "Armature") as? ModelEntity else {
            fatalError("Head Armature not found")
        }
        
        // Create and apply the PBR material.
        let pbrMaterial = MaterialManager.createPBRMaterial(texture: "Head_medium", normal: "Head_Normal")
       // let pbrMaterial = MaterialManager.transparentMaterial()
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
        
        headArmature.orientation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
        
        return headArmature
    }
    
    func updateBodyColor(_ color: BodyColor) {
        guard let headArmature = armature.first else {
            fatalError("Head Armature not found")
        }
        
        // Create and apply the PBR material with the specified color.
        let pbrMaterial = MaterialManager.createPBRMaterial(texture: "Head_\(color.texture)", normal: "Head_Normal", metalness: 0.1,  roughnessTexture: "Head_Roughness")
        headArmature.setMaterial(pbrMaterial)
    }
    
    override func removeAll() {
        updateFaceShape(settings: [FaceShape.smile: 0, FaceShape.blink: 0, FaceShape.jawOpen: 0, FaceShape.pout: 0, FaceShape.frown: 0])
    }
}
