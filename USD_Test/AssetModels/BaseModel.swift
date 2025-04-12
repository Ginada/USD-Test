//
//  BaseModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-22.
//

import RealityKit
import Foundation
import UIKit
import SwiftUICore

class BaseModel {
    
    var earringLeft: ModelEntity?
    var earringRight: ModelEntity?
    
    var selectedAccessoryModel: AssetModel?
    var headModel: ModelEntity?
    var activePlacement: ModelEntity?
    var parent: Entity = Entity()
    var placementObjects: [Entity] = []
    var scaleAnimationTimer: Timer?
    var placements: [ModelEntity] = []
    
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
    func createAttachment(for earring: Entity, on skeleton: ModelEntity, boneName: String, offset: simd_float4x4) -> Attachment? {
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
       
        guard let textureName = model.textures.values.first, let geometryName = model.objNames.first else {return nil}
        // Load the head entity.
        if let entity = try? Entity.load(named: model.sceneName),
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
    func loadModel(from asset: AssetModel, modelName: String, placementName: String) throws -> (earring: ModelEntity, placements: [Entity]) {
        let texture = asset.textures.values.first!
        let normal = asset.normal?.values.first
        let roughness = asset.roughness?.values.first ?? 1.0
        let metalness = asset.metalness?.values.first ?? 0.0
        let material = MaterialManager.createPBRMaterial(texture: texture, normal: normal, metalness: metalness, roughness: roughness, doubleSided: true)
        
        let separated = try EarringsModel.loadAndSeparateEntities(named: asset.sceneName, material: material, modelName: modelName, placementName: placementName)
        let earring = separated.nonEarx
        
        
        earring.setMaterial(material)
        
        // Reparent each placement container to the earring.
        for placement in separated.earxEntities {
            placement.removeFromParent()
            earring.addChild(placement)
        }
        return (earring, separated.earxEntities)
    }
    
    func loadModel(sceneName: String, modelName: String, placementName: String) throws -> (earring: ModelEntity, placements: [Entity]) {
        let material = MaterialManager.transparentMaterial()
        let separated = try EarringsModel.loadAndSeparateEntities(named: sceneName, material: material, modelName: modelName, placementName: placementName)
        let earring = separated.nonEarx
        
        
        earring.setMaterial(material)
        
        // Reparent each placement container to the earring.
        for placement in separated.earxEntities {
            placement.removeFromParent()
            earring.addChild(placement)
        }
        return (earring, separated.earxEntities)
    }
    
    func addScaleAnimation(to entity: Entity) {
        let originalScale = entity.scale
        let targetScale = SIMD3<Float>(0.7, 0.7, 0.7)
        var isScaledDown = false
        
        // Invalidate any previous timer.
        scaleAnimationTimer?.invalidate()
        
        scaleAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
            let newScale = isScaledDown ? originalScale : targetScale
            let currentTransform = entity.transform
            let newTransform = Transform(scale: newScale,
                                         rotation: currentTransform.rotation,
                                         translation: currentTransform.translation)
            entity.move(to: newTransform, relativeTo: entity.parent, duration: 0.6)
            isScaledDown.toggle()
        }
    }
    
    func removeScaleAnimation() {
        scaleAnimationTimer?.invalidate()
        scaleAnimationTimer = nil
    }
    
    func loadModelEntity(
        named targetName: String,
        fromResource resourceName: String
    ) -> ModelEntity {
        let rootEntity = try! Entity.load(named: resourceName)
        guard let targetEntity = rootEntity.findEntity(named: targetName) as? ModelEntity else {
            fatalError("Entity named \(targetName) not found")
        }
        return targetEntity
    }
    
    /// Creates a sphere ModelEntity with a given radius and color.
    private func createSphereEntity(radius: Float = 0.005, color: UIColor = .red) -> ModelEntity {
        let sphereMesh = MeshResource.generateSphere(radius: radius)
        let sphereMaterial = SimpleMaterial(color: color, isMetallic: false)
        let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [sphereMaterial])
        return sphereEntity
    }
    
    /// Replaces each of the placement objects with a sphere clone.
    /// This function assumes that `placementObjects` is an array of Entities that were originally
    /// loaded from the USD file and that they already have their placement (offset) baked in.
    func replacePlacementObjectsWithSpheres(model: ModelEntity, placementObjects: [Entity]) {
        let spherePrototype = createSphereEntity()
        
        for placement in placementObjects {
            guard let modelChild = placement.children.first(where: { $0 is ModelEntity }) as? ModelEntity else {
                continue
            }
            
            let childWorldMatrix = modelChild.transformMatrix(relativeTo: nil)
            let childWorldTransform = Transform(matrix: childWorldMatrix)
            
            let localTransform = placement.convert(transform: childWorldTransform, from: nil)
            
            let sphereClone = spherePrototype.clone(recursive: true)
            sphereClone.name = placement.name
            
            if let outlineMaterial = MaterialManager.createCustomOutlineMaterial() {
                sphereClone.setMaterial(outlineMaterial)
            }
            
            sphereClone.transform = localTransform
         
            sphereClone.generateCollisionShapes(recursive: true)
            placement.addChild(sphereClone)
            modelChild.removeFromParent()
            if placement.parent == nil {
                model.addChild(placement)
            }
            modelChild.removeFromParent()
            let entity = model.findEntity(named: modelChild.name)
            entity?.removeFromParent()
        }
    }
    
    func replaceAccessory(_ entity: ModelEntity) {
        //activePlacement = entity
        if let activePlacement = activePlacement {
            let clone = activePlacement.clone(recursive: true)
            clone.name = "\(activePlacement.id)_accessory"
            placements.append(clone)
            placeEntity(entity, clone)
        }
    }
    
    func placeEntity(_ entity: Entity, _ modelEntity: ModelEntity, mirror: Bool = false) {
        guard let child = entity as? ModelEntity, let parent = child.parent else { return }
        removeScaleAnimation()
        addScaleAnimation(to: parent)
        // Compute the placement transform from the child.
        let worldTransform = Transform(matrix: child.transformMatrix(relativeTo: nil))
        let localTransform = entity.convert(transform: worldTransform, from: nil)
        
        // Preserve the asset’s original scale.
        let originalScale = modelEntity.transform.scale
        var newScale = originalScale
        if parent.parent?.name == "EarringLeft" {
            newScale.x = -abs(newScale.x)
        }
        
        // Build the new transform using the placement's translation and rotation with the asset's scale.
        let newTransform = Transform(scale: newScale, rotation: localTransform.rotation, translation: localTransform.translation)
        modelEntity.transform = newTransform
        
        // Compute orientation: -90° about x plus a 180° about y if on the left earring.
        let rotationX = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
        let rotationY = (parent.parent?.name == "EarringLeft") ? simd_quatf(angle: .pi, axis: SIMD3<Float>(0, 1, 0)) : simd_quatf(angle: 0, axis: SIMD3<Float>(0, 0, 0))
        modelEntity.orientation = rotationX * rotationY
        
        // Clean up non-placement children.
        parent.children.forEach { if !$0.name.contains("placement") { $0.removeFromParent() } }
        
        // Optionally update material on the original child.
        child.model?.materials = [MaterialManager.transparentMaterial()]
        if let assetID = selectedAccessoryModel?.id {
                modelEntity.name = "\(assetID)_accessory"
            }
        parent.addChild(modelEntity)
        
        // Mirror accessory on the corresponding earring.
        let sourceEarring = (entity.parent?.parent?.name == "EarringLeft") ? earringLeft : earringRight
        if let correspondingEntity = sourceEarring?.findEntity(named: entity.name) {
            correspondingEntity.children.forEach {
                if !$0.name.contains("placement") {
                    $0.removeFromParent()
                } else if let childModel = $0 as? ModelEntity {
                    childModel.model?.materials = [MaterialManager.transparentMaterial()]
                }
            }
            let accessoryClone = modelEntity.clone(recursive: true)
            let originalWorldMatrix = modelEntity.transformMatrix(relativeTo: nil)
            let mirrorMatrix = simd_float4x4(diagonal: SIMD4<Float>(-1, 1, 1, 1))
            let mirroredWorldMatrix = mirrorMatrix * originalWorldMatrix
            let mirroredWorldTransform = Transform(matrix: mirroredWorldMatrix)
            let cloneLocalTransform = correspondingEntity.convert(transform: mirroredWorldTransform, from: nil)
            accessoryClone.transform = cloneLocalTransform
            correspondingEntity.addChild(accessoryClone)
        }
    }
    
     func mirrorTransformX(_ transform: Transform) -> Transform {
        // Reflection matrix along X axis.
        let mirrorMatrix = simd_float4x4(diagonal: SIMD4<Float>(-1, 1, 1, 1))
        // Apply the mirror on both sides of the original transform.
        let mirroredMatrix = mirrorMatrix * transform.matrix * mirrorMatrix
        return Transform(matrix: mirroredMatrix)
    }
    
    /// Updates (or creates) the AttachmentComponent on the skeleton with the provided attachments.
    /// - Parameters:
    ///   - skeleton: The head’s skeleton entity.
    ///   - newAttachments: An array of attachments to add.
    func updateSkeletonAttachmentComponent(skeleton: Entity, with newAttachments: [Attachment]) {
        var attachmentComponent: AttachmentComponent
        if let existing = skeleton.components[AttachmentComponent.self] {
            attachmentComponent = existing
        } else {
            attachmentComponent = AttachmentComponent()
        }
        // Append new attachments.
        attachmentComponent.attachments.append(contentsOf: newAttachments)
        skeleton.components.set(attachmentComponent)
    }
    
    @objc func handleAccessoryTap(_ notification: Notification) {
        guard let tappedEntity = notification.object as? ModelEntity else { return }
        // Call the replacement function when an accessory is tapped.
        replaceAccessory(tappedEntity)
    }
    
   
}

