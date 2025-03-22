//
//  EarringsModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-16.
//
import RealityKit
import SwiftUI


struct AccessoryPlacement: Codable {

    var extraRot: Float?
//    var position: SCNVector3
//    var rotation: SCNVector4
//    var scale: SCNVector3
//    var normal: SCNVector3
//    var randomRotate: Bool?
//
//    var bone: ModelBone?
//    var actualPosition: SCNVector3?
//    var actualRotation: SCNVector4?
    var model: AssetModel?
    var accessoryPosition: AccessoryPosition?
}


class EarringsModel: BaseModel, ObservableObject {
    
    var earringLeft: ModelEntity?
    var earringRight: ModelEntity?
    var placementObjects: [Entity] = []
    
    var rightPlacement: [String: AccessoryPlacement] = [:]
    var leftPlacement: [String: AccessoryPlacement] = [:]
    var centerPlacement: [String: AccessoryPlacement] = [:]
    
    override init() {
       super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAccessoryTap(_:)),
                                               name: .accessoryTapped,
                                               object: nil)
    }
    
    /// Loads the earring models on the avatar. This method loads the left earring,
    /// creates a mirrored right earring, replaces placement objects with spheres,
    /// and sets up attachments on the head skeleton.
    /// - Parameter model: The asset model (currently unused in this snippet, but can be used for further customization).
    func loadModelOnAvatar(_ model: AssetModel) {

        removeAll()
        // 1. Retrieve the head's skeleton.
        guard let headModel = headModel, let skeleton = headModel.findEntity(named: "Armature") as? ModelEntity else {
            fatalError("Head skeleton not found")
        }
        
        // 2. Define the offset transform for both attachments.
        let earringOffset = Transform(
            scale: SIMD3<Float>(1, 1, 1),
            rotation: simd_quatf(angle: .pi/2, axis: SIMD3<Float>(1, 0, 0)),
            translation: SIMD3<Float>(0, 0, 0)
        ).matrix
        
        // 3. Load the left earring model and its placement objects.
        let loadedEarring: ModelEntity
        let loadedPlacements: [Entity]
        do {
            (loadedEarring, loadedPlacements) = try loadModel(from: model)
        } catch {
            fatalError("Failed to load earring: \(error)")
        }
        self.earringRight = loadedEarring
        self.placementObjects = loadedPlacements
        if let earringRight = self.earringRight {
           self.replacePlacementObjectsWithSpheres(earringLeft: earringRight, placementObjects: self.placementObjects)
        }
        if let earringRight = self.earringRight {
            self.earringLeft = createMirroredEarring(from: earringRight)
        }
        guard let leftEarring = self.earringLeft,
              let rightEarring = self.earringRight else {
            fatalError("Earring models are not initialized properly.")
        }
        
        guard let leftAttachment = createAttachment(for: leftEarring, on: skeleton, boneName: "Bone_earring_left", offset: earringOffset) else {
            fatalError("Left earring bone not found in head model.")
        }
        guard let rightAttachment = createAttachment(for: rightEarring, on: skeleton, boneName: "Bone_earring_right", offset: earringOffset) else {
            fatalError("Right earring bone not found in head model.")
        }
        parent.addChild(leftEarring)
        parent.addChild(rightEarring)
        
        // 7. Update the skeleton with these attachments.
        updateSkeletonAttachmentComponent(skeleton: skeleton, with: [leftAttachment, rightAttachment])
    }
    
    override func removeAll() {
        // Remove individual earrings if present
        earringLeft?.removeFromParent()
        earringRight?.removeFromParent()
        
        // Remove all placement objects from their parents
        placementObjects.forEach { $0.removeFromParent() }
        
        // Clear class variables
        placementObjects.removeAll()
        earringLeft = nil
        earringRight = nil
    }
    
    /// Mirrors a transform along the X axis.
    private func mirrorTransform(_ transform: Transform) -> Transform {
        let mirrorMatrix = simd_float4x4(diagonal: SIMD4<Float>(-1, 1, 1, 1))
        let newMatrix = mirrorMatrix * transform.matrix
        return Transform(matrix: newMatrix)
    }

    /// Recursively apply the mirror transformation to every child node.
    private func mirrorChildNodes(of entity: Entity) {
        for child in entity.children {
            child.transform = mirrorTransform(child.transform)
            mirrorChildNodes(of: child)
        }
    }

    /// Creates a mirrored clone of the left earring by cloning and then mirroring
    /// the transform of the root and all its child nodes.
    private func createMirroredEarring(from leftEarring: ModelEntity) -> ModelEntity {
        let mirrored = leftEarring.clone(recursive: true)
        mirrored.name = "EarringRight"
        mirrored.transform = mirrorTransform(mirrored.transform)
        mirrorChildNodes(of: mirrored)
        
        return mirrored
    }
    
    
    /// Updates (or creates) the AttachmentComponent on the skeleton with the provided attachments.
    /// - Parameters:
    ///   - skeleton: The head’s skeleton entity.
    ///   - newAttachments: An array of attachments to add.
    private func updateSkeletonAttachmentComponent(skeleton: ModelEntity, with newAttachments: [Attachment]) {
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
    
    func createPlacementModel(model: AssetModel) {
        selectedAccessoryModel = model
        activePlacement = loadAssetModel(model)
    }
    
    /// Loads the USD file and separates its contents into two groups:
    /// - nonEarx: A ModelEntity that contains all objects whose names do NOT contain "earx"
    /// - earxEntities: An array of ModelEntities that have "earx" in their name.
    /// Loads the USD file and separates its contents into two groups:
        /// - nonEarx: A ModelEntity that contains all objects whose names do NOT contain "earx"
        /// - earxEntities: An array of Entities (the placement containers) that have "earx" in their name.
    static func loadAndSeparateEntities(named name: String, material: RealityKit.Material) throws -> (nonEarx: ModelEntity, earxEntities: [Entity]) {
        // Load the entire entity hierarchy from your USD file.
        let rootEntity = try Entity.load(named: name)
        
        // Create a container for all non-"earx" model entities.
        let nonEarxContainer = ModelEntity()
        nonEarxContainer.name = "EarringLeft"
        
        // Array to hold earx placement containers.
        var earxEntities: [Entity] = []
        
        /// Returns true if the entity’s name contains "earx" (case-insensitive).
        func isEarxContainer(_ entity: Entity) -> Bool {
            return entity.name.lowercased().contains("earx")
        }
        
        /// Recursively process the hierarchy.
        func process(entity: Entity) {
            // Log the current entity's name and the number of children.
            print("Processing entity: \(entity.name) with \(entity.children.count) children")
            
            // If the entity is an earx container, add it and don't process its children.
            if isEarxContainer(entity) {
                print(" -> \(entity.name) is an earx container. Adding to earxEntities and returning.")
                earxEntities.append(entity)
                return
            }
            
            // If the entity has a ModelComponent (and is a ModelEntity), add it to nonEarxContainer.
            if entity.components.has(ModelComponent.self),
               let modelEntity = entity as? ModelEntity {
                print(" -> \(entity.name) has a ModelComponent. Adding to nonEarxContainer.")
                modelEntity.setMaterial(material)
                nonEarxContainer.addChild(modelEntity)
            }
            
            // Create a copy of the children array so that any modifications don't affect iteration.
            let childrenCopy = Array(entity.children)
            for (index, child) in childrenCopy.enumerated() {
                print("   Processing child \(index): \(child.name) of \(entity.name)")
    
                process(entity: child)
            }
        }
        
        process(entity: rootEntity)
        return (nonEarx: nonEarxContainer, earxEntities: earxEntities)
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
    func replacePlacementObjectsWithSpheres(earringLeft: ModelEntity, placementObjects: [Entity]) {
        // Create a sphere prototype.
        let spherePrototype = createSphereEntity()
        
        for placement in placementObjects {
            // Look for the first ModelEntity child in the placement.
            guard let modelChild = placement.children.first(where: { $0 is ModelEntity }) as? ModelEntity else {
                continue
            }
            
            // Get the child's world-space transform matrix.
            let childWorldMatrix = modelChild.transformMatrix(relativeTo: nil)
            // Convert the matrix to a Transform.
            let childWorldTransform = Transform(matrix: childWorldMatrix)
            
            // Remove the child model entity.
            modelChild.removeFromParent()
            
            // Convert the child's world-space transform to the placement's local space.
            let localTransform = placement.convert(transform: childWorldTransform, from: nil)
            
            // Clone the sphere prototype.
            let sphereClone = spherePrototype.clone(recursive: true)
            sphereClone.name = placement.name
            
            // Optionally set a custom outline material.
            if let material = MaterialManager.createCustomOutlineMaterial() {
                sphereClone.setMaterial(material)
            }
            
            sphereClone.transform = localTransform
            // Generate collision shapes for hit testing.
            sphereClone.generateCollisionShapes(recursive: true)
            
            // Add the sphere clone as a child of the placement entity.
            placement.addChild(sphereClone)
            
            // Optionally, if the placement isn't parented, add it to earringLeft.
            if placement.parent == nil {
                earringLeft.addChild(placement)
            }
        }
    }
    
    @objc func handleAccessoryTap(_ notification: Notification) {
        guard let tappedEntity = notification.object as? ModelEntity else { return }
        // Call the replacement function when an accessory is tapped.
        replaceAccessory(tappedEntity)
    }
    
    func replaceAccessory(_ entity: ModelEntity) {
        //activePlacement = entity
        if let activePlacement = activePlacement {
            let clone = activePlacement.clone(recursive: true)
            clone.name = "\(activePlacement.id)_accessory"
            placeEntity(entity, clone)
        }
    }
    
    private func placeEntity(_ entity: Entity, _ modelEntity: ModelEntity, mirror: Bool = false) {
        guard let child = entity as? ModelEntity, let parent = child.parent else { return }
        
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
    
    private func mirrorTransformX(_ transform: Transform) -> Transform {
        // Reflection matrix along X axis.
        let mirrorMatrix = simd_float4x4(diagonal: SIMD4<Float>(-1, 1, 1, 1))
        // Apply the mirror on both sides of the original transform.
        let mirroredMatrix = mirrorMatrix * transform.matrix * mirrorMatrix
        return Transform(matrix: mirroredMatrix)
    }
}
