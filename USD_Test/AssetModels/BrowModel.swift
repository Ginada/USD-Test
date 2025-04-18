//
//  BrowModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-15.
//
import RealityKit
import Foundation

class BrowModel: AvatarComponent {
    
    override init() {
        let material = MaterialManager.createPBRMaterial(texture: "brows_reg", normal: nil)
        super.init(resourceName: "model_brows",
                       targetEntityName: "Armature",
                       material: material,
                       orientation: simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0)))
            
        }
    
    func updateBrows(layer: MakeupLayer){
        guard let makeupMat = layer.material else { return }
        let type = layer.asset.type
        
        // Prepare adjusted color.
        let adjustedColor = AvatarComponent.adjustedColor(from: makeupMat)
        let mask = layer.maskImage + "_reg"
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
    
    override func removeAll() {
        updateFaceShape(settings: [FaceShape.smile: 0, FaceShape.blink: 0, FaceShape.jawOpen: 0, FaceShape.pout: 0, FaceShape.frown: 0])
    }
    
    override func updateShape(with shape: FaceShape, weight: CGFloat) {
        armature.forEach {node in
            guard var blendShape = node.components[BlendShapeWeightsComponent.self] else { return }
            var currentWeights = blendShape.weightSet[0].weights
            
            // Determine the blendshape index based on the node's name.
            let blendIndex: Int
            guard let index = shape.browIndex else { return }
            blendIndex = index
            
            guard currentWeights.indices.contains(blendIndex) else { return }
            currentWeights[blendIndex] = Float(weight)
            
            // Update the blendshape component.
            blendShape.weightSet[0].weights = currentWeights
            node.components.set(blendShape)
        }
    }
    
}
