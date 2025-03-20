//
//  AttachmentSystem.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-16.
//
import RealityKit

public struct AttachmentSystem: System {
    // Query for skeleton entities that have an AttachmentComponent.
    let query = EntityQuery(where: .has(AttachmentComponent.self))
    
    public init(scene: Scene) { }
    
    public func update(context: SceneUpdateContext) {
        for skeletonEntity in context.entities(matching: query, updatingSystemWhen: .rendering) {
            guard let skeleton = skeletonEntity as? ModelEntity,
                  let attachmentComponent = skeleton.components[AttachmentComponent.self] else {
                continue
            }
            
            let transforms = skeleton.jointTransforms
            
            // Process each attachment.
            for attachment in attachmentComponent.attachments {
                let jointTransform = attachment.jointIndices.reduce(matrix_identity_float4x4) { partialResult, index in
                    guard index < transforms.count else { return partialResult }
                    return transforms[index].matrix * partialResult
                }
                
                let finalTransform = jointTransform * attachment.offset
                attachment.attachmentEntity.setTransformMatrix(finalTransform, relativeTo: skeleton)
            }
        }
    }
}
