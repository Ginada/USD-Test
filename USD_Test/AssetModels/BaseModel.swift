//
//  BaseModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-22.
//

import RealityKit
import Foundation

class BaseModel {
    
    var selectedAccessoryModel: AssetModel?
    var headModel: ModelEntity?
    var activePlacement: ModelEntity?
    var parent: Entity = Entity()
    
    func removeAll() {
      
    }
    
    func selectAsset(_ asset: AssetModel) {
        selectedAccessoryModel = asset
        activePlacement = loadAssetModel(asset)
    }
    
    func accessoryIds() -> Set<String> {
        return parent.activeAccessoryIDs()
    }
    
    /// Creates an attachment for a given earring on the provided skeleton.
    /// - Parameters:
    ///   - earring: The earring model entity.
    ///   - skeleton: The head’s skeleton entity.
    ///   - boneName: The bone name to attach (e.g., "Bone_earring_left").
    ///   - offset: The transform offset for the attachment.
    /// - Returns: An Attachment if the joint hierarchy is found; otherwise, nil.
    func createAttachment(for earring: ModelEntity, on skeleton: ModelEntity, boneName: String, offset: simd_float4x4) -> Attachment? {
        guard let jointChain = getJointHierarchy(skeleton, for: boneName) else { return nil }
        return Attachment(jointIndices: jointChain, offset: offset, attachmentEntity: earring)
    }
    
    func getJointHierarchy(_ skeleton: ModelEntity, for jointSuffix: String) -> [Int]? {
        guard let targetIndex = skeleton.getJointIndex(suffix: jointSuffix) else {
            return nil
        }
        let targetJointName = skeleton.jointNames[targetIndex]
        var components = targetJointName.components(separatedBy: "/")
        
        var jointChain: [Int] = []
        while !components.isEmpty {
            let jointPath = components.joined(separator: "/")
            if let index = skeleton.jointNames.firstIndex(of: jointPath) {
                jointChain.append(index)
            } else {
                return nil
            }
            components.removeLast()
        }
        
        return jointChain
    }
    
    func loadAssetModel(_ model: AssetModel) -> ModelEntity? {
        guard let url = Bundle.main.url(forResource: model.sceneName, withExtension: "usdc", subdirectory: "Art.scnassets/Accessories") else {
            fatalError("Unable to locate the head model in the bundle")
        }
        guard let textureName = model.textures.values.first, let geometryName = model.objNames.first else {return nil}
        // Load the head entity.
        if let entity = try? Entity.load(contentsOf: url),
           let modelEntity = entity.findEntity(named: model.objNames.first!)?.children.first as? ModelEntity {
            
            let material = MaterialManager.createPBRMaterial(texture: textureName, normal: model.normal?.values.first, doubleSided: true)
            modelEntity.setMaterial(material)
            //set scale
            let scale = model.scale ?? 1.0
            modelEntity.scale = SIMD3<Float>(repeating: Float(scale))
            modelEntity.name = model.objNames.first!
            
            return modelEntity
        }
        
        return nil
    }
    
    /// Loads the earring model and its placement objects from the given asset name.
    /// - Parameter assetName: The name of the USD file.
    /// - Returns: A tuple containing the loaded earring model and its placement objects.
    func loadModel(from asset: AssetModel) throws -> (earring: ModelEntity, placements: [Entity]) {
        let texture = asset.textures.values.first!
        let normal = asset.normal?.values.first
        let roughness = asset.roughness?.values.first ?? 1.0
        let metalness = asset.metalness?.values.first ?? 0.0
        let material = MaterialManager.createPBRMaterial(texture: texture, normal: normal, metalness: metalness, roughness: roughness, doubleSided: true)
        
        let separated = try EarringsModel.loadAndSeparateEntities(named: asset.sceneName, material: material)
        let earring = separated.nonEarx
        
        
        earring.setMaterial(material)
        
        // Reparent each placement container to the earring.
        for placement in separated.earxEntities {
            placement.removeFromParent()
            earring.addChild(placement)
        }
        return (earring, separated.earxEntities)
    }
}
