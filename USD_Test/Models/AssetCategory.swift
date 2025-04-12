//
//  AssetCategory.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2023-12-26.
//

import Foundation

public enum AssetCategory: String, CaseIterable, Codable, Hashable {
    
    case foundation
    case eyeshadow
    case eyeliner
    case eyebrow
    case lashes
    
    case paint
   
    case contouring
    case blush
    case lips

    case fashion
    case hair
    case earrings
    case necklace
    case gems
    case faceGems
    case hairAccessories
    
    case eyeColor
    
    case createEarring
    
    var productImage: String {
        switch self {
        case .fashion:
            return "fashion-dress-ico"
        case .hair:
            return "fashion-hair-ico"
        case .earrings:
            return "fashion-earrings-ico"
        case .necklace:
            return "fashion-necklace-ico"
        case .gems:
            return "fashion-diamond-ico"
        case .eyeColor:
            return "fashion-eye-ico"
        case .hairAccessories:
            return "fashion-diamond-ico"
        default: return ""
        }
    }
    var makeupTypes: [MakeupType] {
        switch self {
        case .foundation:
            return [.foundation]
        case .eyeshadow:
            return [.eyeshadow]
        case .eyeliner:
            return [.eyeliner]
        case .blush:
            return [.rouge]
        case .contouring:
            return [.sculptShadow, .sculptHighlight]
        case .paint:
            return [.foundation]
        case .lips:
            return [.lips, .lipliner]
        default:
            return []
        }
    }
    
    var showRemoveButton: Bool {
        switch self {
        case .paint, .hairAccessories, .gems:
            return true
        default:
            return false
        }
    }
    
    func next() -> AssetCategory? {
        let currentIndex = AssetCategory.allCases.firstIndex(of: self)
        let nextIndex = currentIndex.map { $0 + 1 }

        if let nextIndex = nextIndex, nextIndex < AssetCategory.allCases.count {
            return AssetCategory.allCases[nextIndex]
        }
        return nil
    }
    
    var assetTypes: [String]? {
        switch self {
        case .foundation:
            return ["foundation"]
        case .eyeshadow:
            return ["eyeshadow"]
        case .eyeliner:
            return ["eyeliner"]
        case .contouring:
            return ["sculptShadow", "sculptHighlight", "rouge"]
        case .paint:
            return ["foundation"]
        case .lips:
            return ["lips", "lipliner"]
        default:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .foundation:
            return "Foundation"
        case .eyeshadow:
            return "Eyeshadow"
        case .eyeliner:
            return "Eyeliner"
        case .eyebrow:
            return "Eyebrow"
        case .lashes:
            return "Lashes"
        case .paint:
            return "Paint"
        case .contouring:
            return "Contouring"
        case .lips:
            return "Lips"
        case .fashion:
            return "Fashion"
        case .hair:
            return "Hair"
        case .earrings:
            return "Earrings"
        case .necklace:
            return "Necklace"
        case .gems:
            return "Jewellery"
        case .createEarring:
            return "Create earrings"
        case .faceGems:
            return "Face gems"
        case .eyeColor:
            return "Eye color"
        case .blush:
            return "Blush"
        case .hairAccessories:
            return "Hair accessories"
        }
    }
    
//    var cameraPos: CameraPosition {
//        switch self {
//        case .fashion:
//            return CameraPosition.start
//        case .eyebrow, .eyeliner, .eyeshadow, .lashes, .lips, .eyeColor, .foundation, .paint, .contouring, .blush, .hairAccessories:
//            return CameraPosition.zoomFace
//        case .earrings:
//            return CameraPosition.zoomEar
//        case .createEarring:
//            return CameraPosition.center
//        case .necklace:
//            return CameraPosition.zoomChest
//        case .faceGems:
//            return CameraPosition.zoomForehead
//        default:
//            return CameraPosition.start
//        }
//    }
}
