//
//  MakeupMat.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2023-12-26.
//

import SwiftUI

struct MakeupMat: Equatable, Codable, Hashable {
    
    var id: String
    var color: String
    var finish: MakeupFinish
    var colorIntensity: Int?
    var isClear: Bool?
    
    var uIColor: Color {
        return Color(hex: color)
    }
}

//extension MakeupMat {
//    var bubbleContent: BubbleContent {
//        // If you want to display only a color, leave image as empty.
//        // Use the `id` of the MakeupMat as the unique identifier.
//        return BubbleContent(
//            color: uIColor,
//            image: finish.overlayImage(.eyeshadow) ?? "",
//            id: id
//        )
//    }
//}
//
//extension Array where Element == MakeupMat {
//    var bubbleContent: [BubbleContent] {
//        return self.map { $0.bubbleContent }
//    }
//}
//
//extension Array where Element == HairColor {
//    var bubbleContent: [BubbleContent] {
//        return self.map { $0.bubbleContent }
//    }
//}

//extension Array where Element == HairStyle {
//    var bubbleContent: [BubbleContent] {
//        return self.map { $0.bubbleContent }
//    }
//}
