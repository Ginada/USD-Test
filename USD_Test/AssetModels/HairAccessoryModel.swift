//
//  HairAccessoryModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-23.
//

import RealityKit
import SwiftUI

class HairAccessoryModel: BaseModel, ObservableObject {
    
    override init() {
       super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAccessoryTap(_:)),
                                               name: .accessoryTapped,
                                               object: nil)
    }
    
    func loadModel(_ name: String) {
        
        guard let headModel = headModel, let skeleton = headModel.findEntity(named: "Armature") as? ModelEntity else {
            fatalError("Head skeleton not found")
        }
        
        // 2. Define the offset transform for both attachments.
        let earringOffset = Transform(
            scale: SIMD3<Float>(0.005, 0.005, 0.005),
            rotation: simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0)),
            translation: SIMD3<Float>(0, 0, 0)
        ).matrix
        
        // 3. Load the left earring model and its placement objects.
        let loadedEarring: ModelEntity
        let loadedPlacements: [Entity]
        do {
            (loadedEarring, loadedPlacements) = try loadModel(sceneName: "hair_medium_wayvy_placement_relative", modelName: "Cube", placementName: "hairx")
        } catch {
            fatalError("Failed to load earring: \(error)")
        }
        self.earringRight = loadedEarring
        guard let rightEarring = self.earringRight else {
            fatalError("Earring models are not initialized properly.")
        }
        
        self.placementObjects = loadedPlacements
        if let earringRight = self.earringRight {
            self.replacePlacementObjectsWithSpheres(model: earringRight, placementObjects: self.placementObjects)
        }
        guard let rightAttachment = createAttachment(for: rightEarring, on: skeleton, boneName: "Bone_head", offset: earringOffset) else {
            fatalError("Right earring bone not found in head model.")
        }
        
        parent.addChild(rightEarring)
        updateSkeletonAttachmentComponent(skeleton: skeleton, with: [rightAttachment])
    }
    
    func computeAndCompareOffsets(
        skeleton: ModelEntity,
        headJointIndex: Int,
        child: Entity
    ) {
        // 1) Basic transforms we need.
        let skeletonWorld = skeleton.transformMatrix(relativeTo: nil)
        let boneInSkeleton = skeleton.jointTransforms[headJointIndex].matrix
        
        // The bone's world transform (bone local → world):
        let boneWorld = skeletonWorld * boneInSkeleton
        
        // The child's current world transform:
        let childWorld = child.transformMatrix(relativeTo: nil)
        
        // 2) Some rotation correction (example: -π/2 around X).
        let rotationCorrection = simd_float4x4(
            simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
        )
        
        // -------------------------------------------------------------------------
        // OLD APPROACH:
        //
        // offsetMatrix = inverse(boneInSkeleton)
        //              * inverse(skeletonWorld)
        //              * childWorld
        //
        // finalOffsetMatrix = rotationCorrection * offsetMatrix
        // -------------------------------------------------------------------------
        
        let offsetOld = simd_inverse(boneInSkeleton)
                      * simd_inverse(skeletonWorld)
                      * childWorld
        let finalOffsetOld = rotationCorrection * offsetOld
        
        // Convert to a Transform to easily read out translation/rotation:
        let transformOld = Transform(matrix: finalOffsetOld)
        
        
        // -------------------------------------------------------------------------
        // NEW APPROACH:
        //
        // offsetMatrix = rotationCorrection
        //              * inverse(boneWorld)
        //              * childWorld
        // -------------------------------------------------------------------------
        
        let offsetNew = rotationCorrection
                      * simd_inverse(boneWorld)
                      * childWorld
        let transformNew = Transform(matrix: offsetNew)
        
        
        // 3) Print them out to compare
        print("===== COMPARING OFFSETS =====")
        print("Child Name: \(child.name)")
        
        print("OLD offset -> finalOffset: ")
        print("  translation = \(transformOld.translation)")
        print("  rotation    = \(transformOld.rotation)")
        print("  scale       = \(transformOld.scale)")
        
        print("NEW offset: ")
        print("  translation = \(transformNew.translation)")
        print("  rotation    = \(transformNew.rotation)")
        print("  scale       = \(transformNew.scale)")
        
        print("=============================")
    }
}
