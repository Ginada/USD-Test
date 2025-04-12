//
//  NecklaceModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-22.
//

import RealityKit
import Foundation
import SwiftUI

class NecklaceModel: BaseModel, ObservableObject {
    
    var necklaceModel: ModelEntity?
    
    override init() {
       super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAccessoryTap(_:)),
                                               name: .necklaceAccessoryTapped,
                                               object: nil)
    }
    
//    @objc override func handleAccessoryTap(_ notification: Notification) {
//        guard let tappedEntity = notification.object as? ModelEntity else { return }
//        // Call the replacement function when an accessory is tapped.
//        replaceAccessory(tappedEntity)
//    }
    
    func loadModelOnAvatar(_ model: AssetModel) {
        
        removeAll()
        
        guard let entity = try? Entity.load(named: "chain_6") else {
            return
        }
        guard let armature = entity.findEntity(named: "Armature") as? ModelEntity else {
            fatalError("Head Armature not found")
        }
        let texture = model.textures.values.first!
        let normal = model.normal?.values.first
        let roughness = model.roughness?.values.first ?? 1.0
        let metalness = model.metalness?.values.first ?? 0.0
        let material = MaterialManager.createPBRMaterial(texture: texture, normal: normal, metalness: metalness, roughness: roughness, doubleSided: true)
        armature.setMaterial(material)
        
        let loadedPlacements: [Entity]
        do {
            (_, loadedPlacements) = try loadModel(from: model, modelName: "Armature", placementName: "neckx")
        } catch {
            fatalError("Failed to load earring: \(error)")
        }
        self.placementObjects = loadedPlacements
        armature.orientation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
        self.necklaceModel = armature
        parent.addChild(armature)
        
        self.replacePlacementObjectsWithSpheres(model: armature, placementObjects: self.placementObjects)
    }
    
    func playAnimation(transitionDuration: TimeInterval = 0.3, name: String = "idle") {
        if let clip = AnimationLibrary.shared.animation(for: name) {
            necklaceModel?.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
        }
    }
    
    func setPose(transitionDuration: TimeInterval = 0.3, name: String = "idle") {
        if let clip = AnimationLibrary.shared.pose(for: name) {
            necklaceModel?.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
        }
    }
    
    func stopAnimations() {
        necklaceModel?.stopAllAnimations()
    }
    
}
