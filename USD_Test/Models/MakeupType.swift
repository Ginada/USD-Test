//
//  MakeupType.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2023-12-26.
//

import Foundation

enum MakeupType: String, CaseIterable, Codable, Equatable {
    
    case eyeshadow
    case eyeliner
    case foundation
    case lips
    case rouge
    case sculptShadow
    case sculptHighlight
    case lipliner
    case glitter
    case freckles
    case paint
    case lashes
    case eyebrow
    
    var renderingOrder: Int {
        switch self {
        case .foundation:
            return 1
        case .sculptShadow:
            return 20
        case .sculptHighlight:
            return 30
        case .rouge:
            return 40
        case .paint:
            return 50
        case .freckles:
            return 60
        case .lips:
            return 70
        case .lipliner:
            return 80
        case .eyeshadow:
            return 90
        case .eyeliner:
            return 110
        case .glitter:
            return 140
        case .eyebrow:
            return 150
        case .lashes:
            return 160
        }
    }
    
    var maskBaseName: String {
        switch self {
        case .eyeshadow:
            return "eye_sh"
        case .eyeliner:
            return "eyeliner"
        case .foundation:
            return "face_foun"
        case .lips:
            return "lips"
        case .rouge:
            return "blush"
        case .sculptShadow:
            return "sculpt"
        case .sculptHighlight:
            return "sculpt_high"
        case .lipliner:
            return "lippen"
        case .glitter:
            return "glitter"
        case .freckles:
            return "freckles"
        case .paint:
            return "face_foun"
        case .lashes:
            return "lashes"
        case .eyebrow:
            return "brows"
        }
    }
    
    var thumbName: String {
        switch self {
        case .eyeshadow:
            return "thumb_eye_sh"
        case .eyeliner:
            return "thumb_eyeliner"
        case .foundation:
            return "thumb_foundation"
        case .lips:
            return "thumb_lips"
        case .rouge:
            return "thumb_blush"
        case .sculptShadow:
            return "thumb_sculpt"
        case .sculptHighlight:
            return "thumb_sculpt_high"
        case .lipliner:
            return "thumb_lippen"
        case .glitter:
            return "thumb_glitter"
        case .freckles:
            return "thumb_freckles"
        case .paint:
            return "thumb_foundation"
        case .lashes:
            return "thumb_lashes"
        case .eyebrow:
            return "thumb_eyeBrown"
        }
    }
}
