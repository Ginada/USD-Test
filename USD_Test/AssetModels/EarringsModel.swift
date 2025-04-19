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
            (loadedEarring, loadedPlacements) = try loadModel(from: model, modelName: "EarringLeft", placementName: "earx")
        } catch {
            fatalError("Failed to load earring: \(error)")
        }
        self.earringRight = loadedEarring
        self.placementObjects = loadedPlacements
        if let earringRight = self.earringRight {
           self.replacePlacementObjectsWithSpheres(model: earringRight, placementObjects: self.placementObjects)
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
    
    func placedGemIds() -> [String] {
        let gemIds = placements.compactMap { placement -> String? in
            guard let parent = placement.parent, parent.children.count > 1 else { return nil }
            return parent.children[1].name
        }
        // Use a Set to filter out duplicates.
        let uniqueIds = Array(Set(gemIds))
        // Remove "_accessory" from each id.
        return uniqueIds.map { $0.replacingOccurrences(of: "_accessory", with: "") }
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
        placements.forEach { placement in
            if let clonedPlacement = mirrored.findEntity(named: placement.name), let child = clonedPlacement.children.first as? ModelEntity {
                placements.append(child)
            }
            
        }
       
        //mirrorChildNodes(of: mirrored)
        
        return mirrored
    }
    
//    
//    func createPlacementModel(model: AssetModel) {
//        selectedAccessoryModel = model
//        activePlacement = loadAssetModel(model)
//    }
    
    /// Loads the USD file and separates its contents into two groups:
    /// - nonEarx: A ModelEntity that contains all objects whose names do NOT contain "earx"
    /// - earxEntities: An array of ModelEntities that have "earx" in their name.
    /// Loads the USD file and separates its contents into two groups:
        /// - nonEarx: A ModelEntity that contains all objects whose names do NOT contain "earx"
        /// - earxEntities: An array of Entities (the placement containers) that have "earx" in their name.
    static func loadAndSeparateEntities(named name: String, material: RealityKit.Material, modelName: String, placementName: String) throws -> (nonEarx: ModelEntity, earxEntities: [Entity]) {
        // Load the entire entity hierarchy from your USD file.
        let rootEntity = try Entity.load(named: name)
        
        // Create a container for all non-"earx" model entities.
        let nonEarxContainer = ModelEntity()
        nonEarxContainer.name = modelName
        
        // Array to hold earx placement containers.
        var earxEntities: [Entity] = []
        
        /// Returns true if the entity’s name contains "earx" (case-insensitive).
        func isEarxContainer(_ entity: Entity) -> Bool {
            return entity.name.lowercased().contains(placementName)
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
    
}
