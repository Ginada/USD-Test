//
//  EyesModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-16.
//

import RealityKit
import Foundation
import SwiftUI

class EyesModel: BaseModel, ObservableObject {

    var rightEyeInner: ModelEntity?
    var rightEyeOuter: ModelEntity?
    var leftEyeInner: ModelEntity?
    var leftEyeOuter: ModelEntity?
    
    override init() {
        super.init()
        
        let transparentMaterial = MaterialManager.transparentMaterial()
        
       // let eyesOuterArmature = EyesModel.createModel(name: "eyes_outer_model", material: transparentMaterial)
        // Store both armatures in the array.
    }
    
//    static func createModel(name: String, material: Material) -> ModelEntity {
//        guard let url = Bundle.main.url(forResource: name,
//                                        withExtension: "usdc",
//                                        subdirectory: "Art.scnassets/USD") else {
//            fatalError("Unable to locate resource \(name).usdc in Art.scnassets/USD")
//        }
//        let rootEntity = try! Entity.load(contentsOf: url)
//        guard let armature = rootEntity.findEntity(named: "Armature") as? ModelEntity else {
//            fatalError("Armature not found in \(name)")
//        }
//        armature.setMaterial(material)
//        armature.orientation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
//        return armature
//    }
    
    func createModel(skeleton: ModelEntity) {
        let name = "eyes"
        let innerMaterial = MaterialManager.createPBRMaterial(texture: "Eyes_BaseColor_amber", normal: nil)
        let clearMaterial = MaterialManager.transparentMaterial()
        
        guard let url = Bundle.main.url(forResource: name,
                                        withExtension: "usdc",
                                        subdirectory: "Art.scnassets/USD") else {
            fatalError("Unable to locate resource \(name).usdc in Art.scnassets/USD")
        }
        
        let rootEntity = try! Entity.load(contentsOf: url)
        
        // Common transform offset for all eyes.
        let eyeOffset = Transform(
            scale: SIMD3<Float>(1, 1, 1),
            rotation: simd_quatf(angle: -.pi/4, axis: SIMD3<Float>(1, 0, 0)),
            translation: SIMD3<Float>(0, 0, 0)
        ).matrix
        
        // Helper closure to load an eye (parent and its first child) and create its attachment.
        func loadEye(from entityName: String, boneName: String, useClearMaterial: Bool) -> (parent: Entity, entity: ModelEntity, attachment: Attachment) {
            guard let eyeParent = rootEntity.findEntity(named: entityName) else {
                fatalError("\(entityName) not found")
            }
            guard let eyeEntity = eyeParent.children.first as? ModelEntity else {
                fatalError("No ModelEntity child found in \(entityName)")
            }
            let materialToApply = useClearMaterial ? clearMaterial : innerMaterial
            eyeEntity.setMaterial(materialToApply)
            guard let attachment = createAttachment(for: eyeParent,
                                                    on: skeleton,
                                                    boneName: boneName,
                                                    offset: eyeOffset) else {
                fatalError("\(entityName) attachment could not be created")
            }
            // Add the eye parent to the scene.
            parent.addChild(eyeParent)
            return (parent: eyeParent, entity: eyeEntity, attachment: attachment)
        }
        
        // Load right-eye inner and outer.
        let rightInner = loadEye(from: "Eyes_inner_right", boneName: "Bone_eye_right", useClearMaterial: false)
        rightEyeInner = rightInner.entity
        let rightOuter = loadEye(from: "Eyes_outer_right", boneName: "Bone_eye_right", useClearMaterial: true)
        rightEyeOuter = rightOuter.entity
        
        // Create left-eye copies by cloning the right-eye parents.
        func cloneEye(from rightResult: (parent: Entity, entity: ModelEntity, attachment: Attachment),
                      boneName: String, useClearMaterial: Bool) -> (parent: Entity, entity: ModelEntity, attachment: Attachment) {
            let leftParent = rightResult.parent.clone(recursive: true)
            guard let leftEntity = leftParent.children.first as? ModelEntity else {
                fatalError("Cloned entity missing from left eye")
            }
            let materialToApply = useClearMaterial ? clearMaterial : innerMaterial
            leftEntity.setMaterial(materialToApply)
            guard let leftAttachment = createAttachment(for: leftParent,
                                                        on: skeleton,
                                                        boneName: boneName,
                                                        offset: eyeOffset) else {
                fatalError("Left eye attachment could not be created")
            }
            parent.addChild(leftParent)
            return (parent: leftParent, entity: leftEntity, attachment: leftAttachment)
        }
        
        let leftInner = cloneEye(from: rightInner, boneName: "Bone_eye_left_", useClearMaterial: false)
        leftEyeInner = leftInner.entity
        let leftOuter = cloneEye(from: rightOuter, boneName: "Bone_eye_left_", useClearMaterial: true)
        leftEyeOuter = leftOuter.entity
        
        // Update the skeleton with all four attachments.
        updateSkeletonAttachmentComponent(skeleton: skeleton, with: [
            rightInner.attachment,
            rightOuter.attachment,
            leftInner.attachment,
            leftOuter.attachment
        ])
    }
    
    func updateColor(color: EyeColorModel) {
        let colorMap = "Eyes_BaseColor_\(color.color)"
        let pbrMaterial = MaterialManager.createPBRMaterial(texture: colorMap, normal: nil)
        leftEyeInner?.setMaterial(pbrMaterial)
        rightEyeInner?.setMaterial(pbrMaterial)
    }
    
    /// Updates the rotation of all attached eyes by applying rotations around the local X and Y axes.
    /// - Parameters:
    ///   - xAngle: The rotation angle (in radians) around the X-axis.
    ///   - yAngle: The rotation angle (in radians) around the Y-axis.
    func updateEyeRotation(xAngle: Float, yAngle: Float) {
        // Convert degrees to radians.
        let xAngleRad = xAngle * (.pi / 180)
        let yAngleRad = yAngle * (.pi / 180)
        
        // Create quaternions for rotations around X and Y.
        let xRotation = simd_quatf(angle: xAngleRad, axis: SIMD3<Float>(1, 0, 0))
        let yRotation = simd_quatf(angle: yAngleRad, axis: SIMD3<Float>(0, 1, 0))
        
        // Combine rotations (order matters: yRotation * xRotation means X rotation happens first).
        let combinedRotation = yRotation * xRotation
        
        // Apply the combined rotation to each eye entity.
        rightEyeInner?.orientation = combinedRotation
        rightEyeOuter?.orientation = combinedRotation
        leftEyeInner?.orientation = combinedRotation
        leftEyeOuter?.orientation = combinedRotation
    }
    
    func updateEyeDistance(distance: Float) {
        let distance = distance/1000
       //update position of eyes in x
        rightEyeInner?.position.x = distance
        rightEyeOuter?.position.x = distance
        leftEyeInner?.position.x = -distance
        leftEyeOuter?.position.x = -distance
    }
    
    func updateEyeScale(_ scale: Float) {
        let scale = scale/100
        rightEyeInner?.scale = SIMD3<Float>(scale, scale, scale)
        rightEyeOuter?.scale = SIMD3<Float>(scale, scale, scale)
        leftEyeInner?.scale = SIMD3<Float>(scale, scale, scale)
        leftEyeOuter?.scale = SIMD3<Float>(scale, scale, scale)
    }
}
