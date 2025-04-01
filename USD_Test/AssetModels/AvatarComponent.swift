//
//  AvatarComponent.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-22.
//
import SwiftUI
import RealityKit

class AvatarComponent: ObservableObject {
    var armature: [ModelEntity] = []

    /// Loads a ModelEntity (armature) from a USD file and applies the given material and orientation.
    init(resourceName: String,
         targetEntityName: String = "Armature",
         material: RealityKit.Material? = nil,
         orientation: simd_quatf? = nil) {
        guard let rootEntity = try? Entity.load(named: resourceName) else {
            return
        }
        guard let armatureEntity = rootEntity.findEntity(named: targetEntityName) as? ModelEntity else {
            fatalError("Target entity \(targetEntityName) not found in \(resourceName)")
        }
        if let material = material {
            armatureEntity.setMaterial(material)
        }
        if let orientation = orientation {
            armatureEntity.orientation = orientation
        }
        self.armature.append(armatureEntity)
       
    }
    
    init() {}
    
    func loadModel(_ assetStyle: any AssetStyle) {
        
    }
    
    func updateShape(with shape: FaceShape, weight: CGFloat) {
        armature.forEach {node in
            guard var blendShape = node.components[BlendShapeWeightsComponent.self] else { return }
            var currentWeights = blendShape.weightSet[0].weights
            
            // Determine the blendshape index based on the node's name.
            let blendIndex: Int
            switch node.name {
            case "Eyebrows":
                guard let index = shape.browIndex else { return }
                blendIndex = index
            case "Lashes_upper", "Lashes_lower":
                guard let index = shape.eyelashesIndex else { return }
                blendIndex = index
            default:
                blendIndex = shape.rawValue
            }
            
            guard currentWeights.indices.contains(blendIndex) else { return }
            currentWeights[blendIndex] = Float(weight)
            
            // Update the blendshape component.
            blendShape.weightSet[0].weights = currentWeights
            node.components.set(blendShape)
        }
    }
    
    init(armature: [ModelEntity]) {
        self.armature = armature
    }
    
    /// Plays an animation with the given name.
    func playAnimation(name: String, transitionDuration: TimeInterval = 0.3) {
        if let clip = AnimationLibrary.shared.animation(for: name) {
            armature.forEach { armatur in
                armatur.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
            }
        }
    }
    
    func removeAll() {
        
        for child in armature {
            child.removeFromParent()
        }
        // Clear the armature array as well.
        armature.removeAll()
    }
    
    /// Adjusts the base color according to the makeup material settings.
    static func adjustedColor(from makeupMat: MakeupMat) -> UIColor {
        var color = UIColor(hex: makeupMat.color, alpha: 1)
        if !(color.isLight() ?? false) {
            color = color.lighter(by: CGFloat(makeupMat.finish.lighterPercentage))
        }
        return color
    }
    
    static func extractRoughness(from makeupMat: MakeupMat, type: MakeupType) -> (Float, String?) {
        let roughnessData = makeupMat.finish.rougness(type: type)
        var roughnessValue: Float = 1.0
        var roughnessTexture: String? = nil
        
        if let roughnessColor = roughnessData as? UIColor {
            roughnessValue = Float(roughnessColor.blueValue)
        } else if let textureName = roughnessData as? String {
            roughnessTexture = textureName
        }
        
        return (roughnessValue, roughnessTexture)
    }
}
