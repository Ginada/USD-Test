//
//  HairModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-19.
//
import RealityKit
import Foundation

class HairModel: AvatarComponent {
    
    var parent: Entity = Entity()
    var baseHair: ModelEntity?
    var currentStyle: HairStyleModel?
    
    override init() {
        let material = MaterialManager.createPBRMaterial(texture: "hair_head_brown", normal: nil, roughnessTexture: "hair_head_roughness")
        super.init(resourceName: "hair_head",
                   targetEntityName: "Armature",
                   material: material,
                   orientation: simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0)))
        parent.addChild(armature.first!)
        baseHair = armature.first!
    }
    
    override func loadModel(_ assetStyle: any AssetStyle) {
        guard let style = assetStyle as? HairStyleModel else {
            fatalError("Failed to load hair model.")
        }
        self.currentStyle = style
        do {
            // Load the hair model entity from file.
            let hairModel = try Entity.load(named: style.sceneName)
          
            // Find the armature ModelEntity.
            guard let modelEntity = hairModel.findEntity(named: "Armature") as? ModelEntity else {
                fatalError("Armature not found in hair model.")
            }
            
            removeAll()
            var materials: [RealityKit.Material] = []
            
            // Loop through the submeshModels in order.
            for submesh in modelEntity.children {

                if let matchingKey = style.textures.keys.first(where: { submesh.name == $0 }),
                   let textureName = style.textures[matchingKey] {
                    // Create a material using the texture (and normal, if available).
                    let isDoubleSided = style.doubleSided?.contains(matchingKey) ?? false
                    let material = MaterialManager.createPBRMaterial(texture: textureName + "_brown",
                                                                     normal: style.normal?[matchingKey], metalness: 0, doubleSided: isDoubleSided, roughnessTexture: textureName + "_roughness")
                    materials.append(material)
                } else {
                    // Fallback: assign a default material.
                }
            }
            
            // Assign the array of materials to the ModelEntity.
            // The order of materials corresponds to the order of submeshes.
            modelEntity.setMaterials(materials)
            style.baseHair ? parent.addChild(baseHair!) : baseHair?.removeFromParent()
            
           
            // Save the modelEntity for later use.
            armature.append(modelEntity)
            
            // Add the loaded hair model to the parent.
            parent.addChild(hairModel)
        } catch {
            fatalError("Failed to load hair model: \(error)")
        }
    }
    
    func updateHairColor(color: HairColor) {
        // Update the hair color based on the selected color.
        var materials: [RealityKit.Material] = []
        guard let style = currentStyle else {return}
        // Loop through the submeshModels in order.
        guard let model = armature.first else {return}
        for submesh in model.children {

            if let matchingKey = style.textures.keys.first(where: { submesh.name == $0 }),
               let textureName = style.textures[matchingKey] {
                // Create a material using the texture (and normal, if available).
                let isDoubleSided = style.doubleSided?.contains(matchingKey) ?? false
                let material = MaterialManager.createPBRMaterial(texture: textureName + "_" + color.textureName,
                                                                 normal: style.normal?[matchingKey], metalness: 0, doubleSided: isDoubleSided, roughnessTexture: textureName + "_roughness")
                materials.append(material)
            } else {
                // Fallback: assign a default material.
            }
        }
        
        // Assign the array of materials to the ModelEntity.
        // The order of materials corresponds to the order of submeshes.
        model.setMaterials(materials)
    }
}
