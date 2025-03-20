//
//  Palette.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2024-01-04.
//

import Foundation


enum PaletteType: String, Codable {
    
    case highlight
    case mid
    case shadow
}

struct Palette: Codable {
    
    var name: String
    var id: String
    
    var highlights: [MakeupMat]?
    var mids: [MakeupMat]?
    var shadows: [MakeupMat]
    
    func materials(for type: PaletteType) -> [MakeupMat]? {
        switch type {
        case .highlight:
            return highlights
        case .mid:
            return mids
        case .shadow:
            return shadows
        }
    }
}

extension Palette {
    
    static var eyeshadowPalette: Palette {
        return Palette(name: "Eyeshadow_palette", id: "eyeshadow1", highlights: [
            MakeupMat(id: "4", color: "f4c9a6", finish: .shimmer),
            MakeupMat(id: "8", color: "d0afdc", finish: .matte),
            MakeupMat(id: "5", color: "ebcdc8", finish: .shinygloss)], mids: [
                MakeupMat(id: "3", color: "77322d", finish: .matte),
                MakeupMat(id: "9", color: "77492d", finish: .shimmer),
                MakeupMat(id: "7", color: "a2499d", finish: .dewy)], shadows: [
                    MakeupMat(id: "6", color: "471b0f", finish: .metallic),
                    MakeupMat(id: "2", color: "3f2056", finish: .shimmer),
                    MakeupMat(id: "1", color: "331d1b", finish: .matte)])
    }
    
    static var eyeLinerPalette: Palette {
        return Palette(name: "Eyeliner_palette", id: "eyeliner1", highlights: [
            MakeupMat(id: "4", color: "eebfaa", finish: .matte),
            MakeupMat(id: "8", color: "cc7e6e", finish: .metallic)], mids:
                        [MakeupMat(id: "3", color: "7e4f4b", finish: .matte),
                         MakeupMat(id: "9", color: "9a3eb5", finish: .shimmer)], shadows:
                        [MakeupMat(id: "6", color: "010100", finish: .matte),
                         MakeupMat(id: "2", color: "372f44", finish: .shimmer)])
    }
    
    static var eyebrowPalette: Palette {
        return Palette(name: "Eyeshadow_palette", id: "eyeshadow1", highlights:
                        [], mids:
                        [], shadows:
                        [MakeupMat(id: "4", color: "000000", finish: .satin),
                         MakeupMat(id: "8", color: "61430C", finish: .metallic),
                         MakeupMat(id: "5", color: "6F2045", finish: .matte)])
    }
    
    static var foundationPalette: Palette {
        return Palette(name: "Foundation_palette", id: "foundation1", highlights: [], mids: [], shadows: [MakeupMat(id: "10", color: "ECAE86", finish: .velvet), MakeupMat(id: "11", color: "E0AF7A", finish: .cream), MakeupMat(id: "12", color: "DDAD93", finish: .satin), MakeupMat(id: "13", color: "D5A889", finish: .satin)])
    }
    
    static var lipsPalette: Palette {
        return Palette(name: "Lips_palette", id: "lips1", highlights:
                        [MakeupMat(id: "6", color: "dc638b", finish: .matte),
                         MakeupMat(id: "2", color: "e84e7a", finish: .shimmer),
                         MakeupMat(id: "1", color: "df606f", finish: .matte)], mids:
                        [MakeupMat(id: "3", color: "b63860", finish: .matte),
                         MakeupMat(id: "9", color: "c42435", finish: .matte),
                         MakeupMat(id: "7", color: "bd4685", finish: .metallic)], shadows:
                        [MakeupMat(id: "4", color: "a80004", finish: .matte),
                         MakeupMat(id: "11", color: "441627", finish: .matte),
                         MakeupMat(id: "8", color: "831550", finish: .metallic)])
    }
    
    static var contouringPalette: Palette {
        return Palette(name: "Contouring_palette", id: "contouring1", highlights:
                        [MakeupMat(id: "6", color: "bb9067", finish: .matte), MakeupMat(id: "2", color: "c4988a", finish: .shimmer), MakeupMat(id: "1", color: "dea084", finish: .matte)], mids:
                        [MakeupMat(id: "3", color: "ae6c4c", finish: .matte), MakeupMat(id: "9", color: "c76c50", finish: .matte), MakeupMat(id: "7", color: "d68886", finish: .metallic)], shadows:
                        [MakeupMat(id: "4", color: "6f3f13", finish: .matte), MakeupMat(id: "8", color: "572718", finish: .metallic), MakeupMat(id: "5", color: "3f2e20", finish: .matte), MakeupMat(id: "11", color: "D58573", finish: .matte),
                         MakeupMat(id: "ARKSA70D1_prod", color: "#441627", finish: .matte)])
    }
    
    static func palette(for type: MakeupType) -> Palette {
        switch type {
        case .eyeshadow:
            return eyeshadowPalette
        case .foundation:
            return foundationPalette
        case .eyeliner:
            return eyeLinerPalette
        case .eyebrow, .lashes:
            return eyebrowPalette
        case .sculptShadow, .sculptHighlight, .rouge:
            return contouringPalette
        case .lips, .lipliner:
            return lipsPalette
        default:
            return eyeshadowPalette
        }
    }
    
    static func palette(for category: AssetCategory) -> Palette {
        switch category {
        case .eyeshadow:
            return eyeshadowPalette
        case .foundation:
            return foundationPalette
        case .eyeliner:
            return eyeLinerPalette
        case .eyebrow, .lashes:
            return eyebrowPalette
        case .lips:
            return lipsPalette
        case .contouring:
            return contouringPalette
        default:
            return eyeshadowPalette
        }
    }
    
    static func allPalettes() -> [Palette] {
        return [eyeshadowPalette, eyeLinerPalette, eyebrowPalette, foundationPalette, lipsPalette, contouringPalette]
    }
}
