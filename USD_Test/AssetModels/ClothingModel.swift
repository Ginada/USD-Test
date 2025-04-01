//
//  ClothingModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-27.
//

import SwiftUI
import RealityKit

class ClothingModel: AvatarComponent {
    var parent: Entity = Entity()
    
    override func loadModel(_ assetStyle: any AssetStyle) {
        guard let model = assetStyle as? AssetModel else {
            fatalError("Failed to load hair model.")
        }
        do {
            // Load the hair model entity from file.
            let entity = try Entity.load(named: model.sceneName)
          
            // Find the armature ModelEntity.
            guard let modelEntity = entity.findEntity(named: "Armature") as? ModelEntity else {
                fatalError("Armature not found in hair model.")
            }
            
            removeAll()
            var materials: [RealityKit.Material] = []
            
            model.objNames.forEach { (name) in
                guard let texture = model.textures[name] else {return}
                let normal = model.normal?[name]
                let roughness = model.roughness?[name]
                let metalness = model.metalness?[name]
                let opacity = model.opacity?[name]
                var doubleSided = false
                if let double = model.doubleSided, double.contains(name) {
                    doubleSided = true
                }
                
                let material = MaterialManager.createPBRMaterial(texture: texture,
                                                                 normal: normal, metalness: metalness ?? 0, roughness: roughness ?? 1, doubleSided: doubleSided)
                materials.append(material)
            }
            // Loop through the submeshModels in order.
            
            // Assign the array of materials to the ModelEntity.
            // The order of materials corresponds to the order of submeshes.
            modelEntity.setMaterials(materials)
           let orientation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
            entity.orientation = orientation
            // Save the modelEntity for later use.
            armature.append(modelEntity)
            
            // Add the loaded hair model to the parent.
            parent.addChild(entity)
        } catch {
            fatalError("Failed to load hair model: \(error)")
        }
    }
    
    override func removeAll() {
        for child in armature {
            child.removeFromParent()
        }
        // Clear the armature array as well.
        armature.removeAll()
    }
    
}
