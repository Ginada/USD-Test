//
//  LashesModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-16.
//

import RealityKit
import Foundation

class LashesModel: AvatarComponent {
    
    override init() {
        let material = MaterialManager.createPBRMaterial(texture: "lashes_1", normal: nil, doubleSided: true)
        
        // Call the superclass initializer.
        super.init(resourceName: "model_lashes",
                   targetEntityName: "Armature",
                   material: material,
                   orientation: simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0)))
        
    }
    
    override func updateShape(with shape: FaceShape, weight: CGFloat) {
        armature.forEach {node in
            guard var blendShape = node.components[BlendShapeWeightsComponent.self] else { return }
            var currentWeights = blendShape.weightSet[0].weights
            
            // Determine the blendshape index based on the node's name.
            let blendIndex: Int
            
            guard let index = shape.eyelashesIndex else { return }
            blendIndex = index
            
            guard currentWeights.indices.contains(blendIndex) else { return }
            currentWeights[blendIndex] = Float(weight)
            
            // Update the blendshape component.
            blendShape.weightSet[0].weights = currentWeights
            node.components.set(blendShape)
        }
    }
    
    func updateLashes(layer: MakeupLayer){
        guard let makeupMat = layer.material else { return }
        let type = layer.asset.type
        
        // Prepare adjusted color.
        let adjustedColor = AvatarComponent.adjustedColor(from: makeupMat)
        let mask = layer.maskImage
        let normalMapName = makeupMat.finish.normal(type: type, dimples: false)
        
        let makeupEntity = armature.first!
        
        // Calculate material parameters.
        let opacity: Float = (makeupMat.isClear ?? false)
            ? ((layer.transparency ?? 1.0) / 2)
            : (layer.transparency ?? 0.7)
        
        let (roughnessValue, roughnessTexture) = AvatarComponent.extractRoughness(from: makeupMat, type: type)
        let metalnessValue: Float = Float(makeupMat.finish.metalness(type: type).blueValue)
        
        // Create and assign the new material.
        let newMaterial = MaterialManager.makeupMaterial(
            color: adjustedColor,
            normal: normalMapName,
            opacity: opacity,
            mask: mask,
            roughness: roughnessValue,
            roughnessTexture: roughnessTexture,
            metalness: metalnessValue
        )
        makeupEntity.setMaterial(newMaterial)
    }
}
