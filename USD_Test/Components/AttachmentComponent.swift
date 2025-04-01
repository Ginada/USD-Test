//
//  AttachmentComponent.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-16.
//

import RealityKit

public struct Attachment {
    var jointIndices: [Int]
    var offset: simd_float4x4
    var attachmentEntity: Entity
}

public struct AttachmentComponent: Component {
    var attachments: [Attachment] = []
   // let headEntity: ModelEntity
}
