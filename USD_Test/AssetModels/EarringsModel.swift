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


class EarringsModel: ObservableObject {
    
    var earringLeft: ModelEntity
    var earringRight: ModelEntity
    var placementObjects: [Entity] = []
    
    var rightPlacement: [String: AccessoryPlacement] = [:]
    var leftPlacement: [String: AccessoryPlacement] = [:]
    var centerPlacement: [String: AccessoryPlacement] = [:]
    var selectedModel: AssetModel?
    
    init() {
        // 1. Set up the selected model.
        selectedModel = AssetModel(id: "1", type: .gems,
                                   thumbName: "thumb_crystal_36",
                                   thumbUrl: "",
                                   sceneName: "shell_round",
                                   objNames: ["shell_round"],
                                   textures: ["shell_round": "shell_color.jpg"],
                                   opacity: nil,
                                   roughness: ["shell_round": 0.2],
                                   metalness: ["shell_round": 0.2],
                                   normal: ["shell_round": "shell_normal.jpg"],
                                   doubleSided: nil,
                                   scale: 1,
                                   tags: [ThemeTag.clouds, ThemeTag.fairy],
                                   unlockType: UnlockType.coins,
                                   pointLevel: .basic,
                                   unlockAmount: 1)
        
        // 2. Load the USD file and get temporary values.
        let tempEarringLeft: ModelEntity
        let tempPlacementObjects: [Entity]
        do {
            let separated = try EarringsModel.loadAndSeparateEntities(named: "earring_hollow_loop")
            tempEarringLeft = separated.nonEarx
            tempPlacementObjects = separated.earxEntities
            
            // Optionally apply a metallic material to the temp earring.
            let material = MaterialManager.metallicMaterial(color: .yellow)
            tempEarringLeft.setMaterial(material)
            
            // Reparent placement containers to the temp earring.
            for placement in tempPlacementObjects {
                placement.removeFromParent()
                tempEarringLeft.addChild(placement)
            }
        } catch {
            fatalError("Failed to load earring: \(error)")
        }
        
        // 3. Assign computed values to self.
        self.earringLeft = tempEarringLeft
        self.placementObjects = tempPlacementObjects
        // Temporarily initialize earringRight with a dummy instance.
        self.earringRight = ModelEntity()
        
        // 4. Now that all stored properties are initialized, you can call instance methods.
        self.replacePlacementObjectsWithSpheres(earringLeft: self.earringLeft,
                                                 placementObjects: self.placementObjects)
        
        // 5. Create a mirrored clone of earringLeft for earringRight.
        self.earringRight = self.earringLeft.clone(recursive: true)
        var mirroredScale = self.earringRight.scale
        mirroredScale.x = -abs(mirroredScale.x)  // Mirror along the X axis.
        self.earringRight.scale = mirroredScale
        
        // 6. Register for accessory tap notifications.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAccessoryTap(_:)),
                                               name: .accessoryTapped,
                                               object: nil)
    }

    /// Loads the USD file and separates its contents into two groups:
    /// - nonEarx: A ModelEntity that contains all objects whose names do NOT contain "earx"
    /// - earxEntities: An array of ModelEntities that have "earx" in their name.
    /// Loads the USD file and separates its contents into two groups:
        /// - nonEarx: A ModelEntity that contains all objects whose names do NOT contain "earx"
        /// - earxEntities: An array of Entities (the placement containers) that have "earx" in their name.
    static func loadAndSeparateEntities(named name: String) throws -> (nonEarx: ModelEntity, earxEntities: [Entity]) {
        // Load the entire entity hierarchy from your USD file.
        let rootEntity = try Entity.load(named: name)
        
        // Create a container for all non-"earx" model entities.
        let nonEarxContainer = ModelEntity()
        nonEarxContainer.name = "NonEarxContainer"
        
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
                let material = MaterialManager.metallicMaterial(color: .yellow)
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
    func createSphereEntity(radius: Float = 0.005, color: UIColor = .red) -> ModelEntity {
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
        if let model = selectedModel, let assetModel = loadAssetModel(model) {
            placeEntity(entity, assetModel)
        }
    }
    
    private func placeEntity(_ entity: Entity, _ modelEntity: ModelEntity, mirror: Bool = false) {
        // Get the first child model entity.
        guard let child = entity as? ModelEntity, let parent = child.parent else { return }
        
        // Capture the child's world transform.
        let worldTransform = Transform(matrix: child.transformMatrix(relativeTo: nil))
        
        // Convert the world transform into the parent's (entity's) local space.
        let localTransform = entity.convert(transform: worldTransform, from: nil)
        
        modelEntity.transform = localTransform
        // rotate -90 deg in x
        modelEntity.orientation = simd_quatf(angle: .pi/2, axis: SIMD3<Float>(1, 0, 0))
        parent.children.forEach { (child) in
            if !child.name.contains("placement") {
                child.removeFromParent()
            }
        }
        // Add the modelEntity as a child of the parent entity.
        parent.addChild(modelEntity)

    }
    
    func loadAssetModel(_ model: AssetModel) -> ModelEntity? {
        guard let url = Bundle.main.url(forResource: model.sceneName, withExtension: "usdc", subdirectory: "Art.scnassets/Accessories") else {
            fatalError("Unable to locate the head model in the bundle")
        }
        guard let textureName = model.textures.values.first, let geometryName = model.objNames.first else {return nil}
        // Load the head entity.
        if let entity = try? Entity.load(contentsOf: url),
           let modelEntity = entity.findEntity(named: model.objNames.first!)?.children.first as? ModelEntity {
            
            let material = MaterialManager.createPBRMaterial(texture: textureName, normal: model.normal?.values.first, doubleSided: model.doubleSided?.first != nil ? true : false)
            modelEntity.setMaterial(material)
            modelEntity.name = model.objNames.first!
            return modelEntity
        }
        
        return nil
    }
}
