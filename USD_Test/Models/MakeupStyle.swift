//
//  MakeupStyle.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2023-12-26.
//

import Foundation

enum UnlockType: String, Codable {
    case likes
    case ad
    case coins
    case diamonds
    case stars
    case free
    case tag
}

enum PointLevel: String, Codable, Hashable {
    case basic
    case premium
    case exclusive
}

struct MakeupStyle: AssetStyle, Codable, Equatable, Identifiable  {
    
    static func == (lhs: MakeupStyle, rhs: MakeupStyle) -> Bool {
        return lhs.id == rhs.id
    }
    var id: String
    var type: AssetCategory
    var secondaryChallengeId: String?
    var layers: [MakeupLayer]
    var thumbName: String?
    var thumbUrl: String
    var paletteId: String
    var modelId: String?
    var challengeId: String?
    var shared: Bool?
    var theme: Theme?
    var tags: [ThemeTag]?
    var unlockType: UnlockType?
    var pointLevel: PointLevel?
    var unlockAmount: Int?
    var boxUnlockableId: String?
}

protocol AssetStyle: Equatable, Identifiable  {
    
    static func == (lhs: Self, rhs: Self) -> Bool
    var id: String { get set }
    var type: AssetCategory { get set }
    var thumbName: String? { get set }
    var thumbUrl: String { get set }
    var modelId: String? {get}
    var challengeId: String? {get}
    var secondaryChallengeId: String? {get}
    var tags: [ThemeTag]? {get}
    var theme: Theme? {get}
    var shared: Bool?{get}
    var unlockType: UnlockType?{get}
    var pointLevel: PointLevel?{get}
    var unlockAmount: Int?{get}
    var boxUnlockableId: String?{get}
}

// load makeupstyles for assetCateogry
// apply makeup
// create makeup styles

//

extension MakeupStyle {
    static func mockedEyeShadowData() -> [any AssetStyle] {
        var styles = [MakeupStyle]()
        
        let material = MakeupMat(id: "3", color: "#8c3861", finish: .metallic)
        let asset1 = MakeupAsset(id: "asset1", type: .eyeshadow, mask: 8)
        let layer = MakeupLayer(asset: asset1, order: 0, blur: 1, transparency: 0.9, material: material, paletteType: .shadow)
        
        let material2 = MakeupMat(id: "4", color: "#d2042d", finish: .satin)
        let asset2 = MakeupAsset(id: "asset2", type: .eyeshadow, mask: 10)
        let layer2 = MakeupLayer(asset: asset2, order: 1, blur: 2, transparency: 0.8, material: material2, paletteType: .mid)
        
        let material3 = MakeupMat(id: "5", color: "#dcebfc", finish: .satin)
        let asset3 = MakeupAsset(id: "asset3", type: .eyeshadow, mask: 12)
        let layer3 = MakeupLayer(asset: asset3, order: 2, blur: 0, transparency: 0.6, material: material3, paletteType: .highlight)
        styles.append(MakeupStyle(id: "1", type: .eyeshadow, layers: [layer, layer2, layer3], thumbName: "Style_1", thumbUrl: "", paletteId: Palette.eyeshadowPalette.id, unlockType: .diamonds, pointLevel: .basic, unlockAmount: 190))
        
        let material4 = MakeupMat(id: "6", color: "#8c3861", finish: .metallic)
        let asset4 = MakeupAsset(id: "asset4", type: .eyeshadow, mask: 2)
        let layer4 = MakeupLayer(asset: asset4, order: 0, blur: 1, transparency: 0.9, material: material4, paletteType: .shadow)
        
        let material5 = MakeupMat(id: "7", color: "#d2042d", finish: .satin)
        let asset5 = MakeupAsset(id: "asset5", type: .eyeshadow, mask: 5)
        let layer5 = MakeupLayer(asset: asset5, order: 1, blur: 2, transparency: 0.8, material: material5, paletteType: .mid)
        
        let material6 = MakeupMat(id: "8", color: "#dcebfc", finish: .satin)
        let asset6 = MakeupAsset(id: "asset6", type: .eyeshadow, mask: 6)
        let layer6 = MakeupLayer(asset: asset6, order: 2, blur: 0, transparency: 0.6, material: material6, paletteType: .highlight)
        styles.append(MakeupStyle(id: "2", type: .eyeshadow, layers: [layer4, layer5, layer6], thumbName: "Style_2", thumbUrl: "", paletteId: Palette.eyeshadowPalette.id, unlockType: .coins, pointLevel: .basic, unlockAmount: 90))
        
        let material7 = MakeupMat(id: "9", color: "#8c3861", finish: .metallic)
        let asset7 = MakeupAsset(id: "asset7", type: .eyeshadow, mask: 2)
        let layer7 = MakeupLayer(asset: asset7, order: 0, blur: 1, transparency: 1, material: material7, paletteType: .shadow)
        
        let material8 = MakeupMat(id: "10", color: "#d2042d", finish: .satin)
        let asset8 = MakeupAsset(id: "asset8", type: .eyeshadow, mask: 3)
        let layer8 = MakeupLayer(asset: asset8, order: 1, blur: 2, transparency: 0.8, material: material8, paletteType: .mid)
        
        let material9 = MakeupMat(id: "11", color: "#dcebfc", finish: .satin)
        let asset9 = MakeupAsset(id: "asset9", type: .eyeshadow, mask: 7)
        let layer9 = MakeupLayer(asset: asset9, order: 2, blur: 0, transparency: 0.8, material: material9, paletteType: .highlight)
        styles.append(MakeupStyle(id: "3", type: .eyeshadow, layers: [layer7, layer8, layer9], thumbName: "Style_3", thumbUrl: "", paletteId: Palette.eyeshadowPalette.id))
        
        return styles
    }

    
    static func mockedFoundationData() -> [any AssetStyle] {
        var styles = [MakeupStyle]()
        
        let material = MakeupMat(id: "12", color: "#F3C58E", finish: .metallic)
        let asset1 = MakeupAsset(id: "asset1", type: .foundation, mask: 1)
        let layer = MakeupLayer(asset: asset1, order: 0, blur: 1, transparency: 0.9, material: material, paletteType: .shadow, paletteIndex: 0)
        styles.append(MakeupStyle(id: "1", type: .foundation, layers: [layer], thumbName: "foundation_1", thumbUrl: "", paletteId: Palette.foundationPalette.id))
        
        let material2 = MakeupMat(id: "13", color: "#D5A889", finish: .satin)
        let asset2 = MakeupAsset(id: "asset2", type: .foundation, mask: 1)
        let layer2 = MakeupLayer(asset: asset2, order: 0, blur: 2, transparency: 0.8, material: material2, paletteType: .shadow, paletteIndex: 1)
        styles.append(MakeupStyle(id: "2", type: .foundation, layers: [layer2], thumbName: "foundation_1", thumbUrl: "", paletteId: Palette.foundationPalette.id))
        
        let material3 = MakeupMat(id: "14", color: "#E3AF84", finish: .satin)
        let asset3 = MakeupAsset(id: "asset3", type: .foundation, mask: 1)
        let layer3 = MakeupLayer(asset: asset3, order: 0, blur: 0, transparency: 0.6, material: material3, paletteType: .shadow, paletteIndex: 2)
        styles.append(MakeupStyle(id: "3", type: .foundation, layers: [layer3], thumbName: "foundation_1", thumbUrl: "", paletteId: Palette.foundationPalette.id))
        
        return styles
    }
    
    static func mockedEyelinerData() -> [any AssetStyle] {
        var styles = [MakeupStyle]()

        let material = MakeupMat(id: "12", color: "#F3C58E", finish: .metallic)
        let asset1 = MakeupAsset(id: "asset1", type: .eyeliner, mask: 2)
        let layer = MakeupLayer(asset: asset1, order: 0, blur: 0, transparency: 1, material: material, paletteType: .shadow, paletteIndex: 0)
        styles.append(MakeupStyle(id: "1", type: .eyeliner, layers: [layer], thumbName: "thumb_eyeliner_1", thumbUrl: "", paletteId: Palette.eyeLinerPalette.id))

        let material2 = MakeupMat(id: "13", color: "#D5A889", finish: .satin)
        let asset2 = MakeupAsset(id: "asset2", type: .eyeliner, mask: 16)
        let layer2 = MakeupLayer(asset: asset2, order: 0, blur: 2, transparency: 0.8, material: material2, paletteType: .shadow, paletteIndex: 0)
        styles.append(MakeupStyle(id: "2", type: .eyeliner, layers: [layer2], thumbName: "thumb_eyeliner_2", thumbUrl: "", paletteId: Palette.eyeLinerPalette.id))

        let material3 = MakeupMat(id: "14", color: "#E3AF84", finish: .satin)
        let asset3 = MakeupAsset(id: "asset3", type: .eyeliner, mask: 8)
        let layer3 = MakeupLayer(asset: asset3, order: 0, blur: 0, transparency: 0.9, material: material3, paletteType: .shadow, paletteIndex: 0)
        let asset4 = MakeupAsset(id: "asset4", type: .eyeliner, mask: 14)
        let layer4 = MakeupLayer(asset: asset4, order: 1, blur: 0, transparency: 1, material: material3, paletteType: .shadow, paletteIndex: 0)

        styles.append(MakeupStyle(id: "3", type: .eyeliner, layers: [layer3, layer4], thumbName: "thumb_eyeliner_3", thumbUrl: "", paletteId: Palette.eyeLinerPalette.id))

        return styles
    }
    
    static func mockeEyebrowData() -> [any AssetStyle] {
        var styles = [MakeupStyle]()

        let material = MakeupMat(id: "12", color: "#F3C58E", finish: .metallic)
        
        let asset1 = MakeupAsset(id: "asset1", type: .eyebrow, mask: 1)
        let layer = MakeupLayer(asset: asset1, order: 0, blur: 0, transparency: 1, material: material, paletteType: .shadow, paletteIndex: 0)
        styles.append(MakeupStyle(id: "1", type: .eyebrow, layers: [layer], thumbName: "thumb_eyeBrow_1", thumbUrl: "", paletteId: Palette.eyebrowPalette.id))
        
        let asset2 = MakeupAsset(id: "asset2", type: .eyebrow, mask: 4)
        let layer2 = MakeupLayer(asset: asset2, order: 0, blur: 0, transparency: 1, material: material, paletteType: .shadow, paletteIndex: 0)
        styles.append(MakeupStyle(id: "4", type: .eyebrow, layers: [layer2], thumbName: "thumb_eyeBrow_2", thumbUrl: "", paletteId: Palette.eyebrowPalette.id))
        
        let asset3 = MakeupAsset(id: "asset3", type: .eyebrow, mask: 5)
        let layer3 = MakeupLayer(asset: asset3, order: 0, blur: 0, transparency: 1, material: material, paletteType: .shadow, paletteIndex: 0)
        styles.append(MakeupStyle(id: "5", type: .eyebrow, layers: [layer3], thumbName: "thumb_eyeBrow_3", thumbUrl: "", paletteId: Palette.eyebrowPalette.id))
        
        // This seems to be a duplicate of layer2 but with a different style id, assuming unique assets for each style
        let asset4 = MakeupAsset(id: "asset4", type: .eyebrow, mask: 4)
        let layer4 = MakeupLayer(asset: asset4, order: 0, blur: 0, transparency: 1, material: material, paletteType: .shadow, paletteIndex: 0)
        styles.append(MakeupStyle(id: "7", type: .eyebrow, layers: [layer4], thumbName: "thumb_eyeBrow_4", thumbUrl: "", paletteId: Palette.eyebrowPalette.id))

        return styles
    }

    static func mockedLashesData() -> [any AssetStyle] {
        var styles = [MakeupStyle]()

        let material = MakeupMat(id: "12", color: "#F3C58E", finish: .metallic)
        
        let asset1 = MakeupAsset(id: "asset1", type: .lashes, mask: 1, morphValue: nil)
        let layer = MakeupLayer(asset: asset1, order: 0, blur: 0, transparency: 1, material: material, paletteType: .shadow, paletteIndex: 0)
        styles.append(MakeupStyle(id: "1", type: .lashes, layers: [layer], thumbName: "thumb_eyelash_1", thumbUrl: "", paletteId: Palette.eyebrowPalette.id))
        
        let asset2 = MakeupAsset(id: "asset2", type: .lashes, mask: 4, morphValue: nil)
        let layer2 = MakeupLayer(asset: asset2, order: 0, blur: 0, transparency: 1, material: material, paletteType: .shadow, paletteIndex: 0)
        styles.append(MakeupStyle(id: "4", type: .lashes, layers: [layer2], thumbName: "thumb_eyelash_2", thumbUrl: "", paletteId: Palette.eyebrowPalette.id))
        
        let asset3 = MakeupAsset(id: "asset3", type: .lashes, mask: 5, morphValue: 0.5)
        let layer3 = MakeupLayer(asset: asset3, order: 0, blur: 0, transparency: 1, material: material, paletteType: .shadow, paletteIndex: 0)
        styles.append(MakeupStyle(id: "5", type: .lashes, layers: [layer3], thumbName: "thumb_eyelash_3", thumbUrl: "", paletteId: Palette.eyebrowPalette.id))
        
        let asset4 = MakeupAsset(id: "asset4", type: .lashes, mask: 4, morphValue: 1)
        let layer4 = MakeupLayer(asset: asset4, order: 0, blur: 0, transparency: 1, material: material, paletteType: .shadow, paletteIndex: 0)
        styles.append(MakeupStyle(id: "7", type: .lashes, layers: [layer4], thumbName: "thumb_eyelash_4", thumbUrl: "", paletteId: Palette.eyebrowPalette.id))

        return styles
    }

    
    static func mockedSculptingData() -> [any AssetStyle] {
        var styles = [MakeupStyle]()
        
        // For sculptShadow
        let asset1 = MakeupAsset(id: "asset1", type: .sculptShadow, mask: 2)
        let layer = MakeupLayer(asset: asset1, order: 0, blur: 2, transparency: 0.8, material: nil, paletteType: .shadow, paletteIndex: 0)
        
        // For sculptHighlight
        let asset2 = MakeupAsset(id: "asset2", type: .sculptHighlight, mask: 4)
        let layer2 = MakeupLayer(asset: asset2, order: 0, blur: 2, transparency: 0.5, material: nil, paletteType: .highlight, paletteIndex: 0)
        
        styles.append(MakeupStyle(id: "1", type: .contouring, layers: [layer, layer2], thumbName: "sculpting_1", thumbUrl: "", paletteId: Palette.contouringPalette.id))
        
        // Another set of sculpting with shadow, highlight, and rouge
        let asset3 = MakeupAsset(id: "asset3", type: .sculptShadow, mask: 1)
        let layer3 = MakeupLayer(asset: asset3, order: 0, blur: 1, transparency: 0.8, material: nil, paletteType: .shadow, paletteIndex: 0)
        
        let asset4 = MakeupAsset(id: "asset4", type: .sculptHighlight, mask: 5)
        let layer4 = MakeupLayer(asset: asset4, order: 0, blur: 2, transparency: 0.8, material: nil, paletteType: .highlight, paletteIndex: 0)
        
        let asset5 = MakeupAsset(id: "asset5", type: .rouge, mask: 5)
        let layer5 = MakeupLayer(asset: asset5, order: 0, blur: 2, transparency: 0.8, material: nil, paletteType: .mid, paletteIndex: 0)
        
        styles.append(MakeupStyle(id: "2", type: .contouring, layers: [layer3, layer4, layer5], thumbName: "sculpting_2", thumbUrl: "", paletteId: Palette.contouringPalette.id))
        
        return styles
    }

    static func mockedLipData() -> [any AssetStyle] {
        var styles = [MakeupStyle]()
        
        // Lips layer
        let asset1 = MakeupAsset(id: "asset1", type: .lips, mask: 2)
        let layer = MakeupLayer(asset: asset1, order: 0, blur: 0, transparency: 1, material: nil, paletteType: .highlight, paletteIndex: 0)
        
        // Lipliner layer
        let asset2 = MakeupAsset(id: "asset2", type: .lipliner, mask: 4)
        let layer2 = MakeupLayer(asset: asset2, order: 0, blur: 2, transparency: 0.5, material: nil, paletteType: .shadow, paletteIndex: 0)
        
        styles.append(MakeupStyle(id: "1", type: .lips, layers: [layer, layer2], thumbName: "lip_1", thumbUrl: "", paletteId: Palette.lipsPalette.id))
        
        // Another lips layer
        let asset3 = MakeupAsset(id: "asset3", type: .lips, mask: 1)
        let layer3 = MakeupLayer(asset: asset3, order: 0, blur: 0, transparency: 1, material: nil, paletteType: .highlight, paletteIndex: 0)
        
        // Another lipliner layer
        let asset4 = MakeupAsset(id: "asset4", type: .lipliner, mask: 5)
        let layer4 = MakeupLayer(asset: asset4, order: 0, blur: 0, transparency: 1, material: nil, paletteType: .shadow, paletteIndex: 0)
        
        styles.append(MakeupStyle(id: "2", type: .lips, layers: [layer3, layer4], thumbName: "lip_2", thumbUrl: "", paletteId: Palette.lipsPalette.id))
        
        // Additional lips layer
        let asset5 = MakeupAsset(id: "asset5", type: .lips, mask: 4)
        let layer5 = MakeupLayer(asset: asset5, order: 0, blur: 0, transparency: 1, material: nil, paletteType: .shadow, paletteIndex: 0)
        
        styles.append(MakeupStyle(id: "3", type: .lips, layers: [layer5], thumbName: "lip_3", thumbUrl: "", paletteId: Palette.lipsPalette.id))
        
        return styles
    }
    
    static func mockedEarringData() -> [any AssetStyle] {
        var styles = [MakeupStyle]()
        return styles
    }
}


