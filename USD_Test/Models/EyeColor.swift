//
//  EyeColor.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2023-12-23.
//

import UIKit
import SwiftUI

public enum EyeColor: Int, Codable {
    
    case brightBlue = 1
    case blue = 2
    case brown = 3
    case hazel = 4
    case amber = 5
    case darkBrown = 6
    case green = 7
    case amethystGreen = 8
    case azure = 9
    case violet = 10
    case gray = 11
    case red = 12
    case black = 13
    case white = 14
    case white_pupil = 15
    case black_all = 16
    case amber_halo = 17
    case blue_halo = 18
    case green_halo = 19
    case yellow_halo = 20
    case yellow_cat = 21
    case blue_cat = 22
    case green_cat = 23
    case blackCornea = 24
    case yellowGreen = 25
    case brightGreen = 26
    case darkGreen = 27
    case darkBlue = 28
    case LGTBI = 29
    case galaxy = 30
    case redBlack = 31
   
    case festive = 32
    case pink = 33
    case sharingan = 34
    case greenPaint = 35
    case blackPaint = 36
    case redPaint = 37
    case eclipse = 38
    

    public var eyeTexture: UIImage? {
        let basePath = "Art.scnassets/textures/eyes/Eyes_BaseColor_"
        let textureName: String

        switch self {
        case .brightBlue:
            textureName = "brightBlue"
        case .blue:
            textureName = "blue"
        case .darkBrown:
            textureName = "darkBrown"
        case .brown:
            textureName = "brown"
        case .green:
            textureName = "green"
        case .hazel:
            textureName = "hazel"
        case .amber:
            textureName = "amber"
        case .amethystGreen:
            textureName = "amethystGreen"
        case .violet:
            textureName = "violet"
        case .azure:
            textureName = "azure"
        case .gray:
            textureName = "gray"
        case .red:
            textureName = "red"
        case .black:
            textureName = "black"
        case .white:
            textureName = "white"
        case .white_pupil:
            textureName = "white_pupil"
        case .black_all:
            textureName = "black_all"
        case .amber_halo:
            textureName = "amber_halo"
        case .yellow_halo:
            textureName = "yellow_halo"
        case .yellow_cat:
            textureName = "yellow_cat"
        case .blue_cat:
            textureName = "blue_cat"
        case .blue_halo:
            textureName = "blue_halo"
        case .green_halo:
            textureName = "green_halo"
        case .green_cat:
            textureName = "green_cat"
        case .blackCornea:
            textureName = "Black"
        case .yellowGreen:
            textureName = "YellowGreen"
        case .brightGreen:
            textureName = "BrightGreen"
        case .darkGreen:
            textureName = "DarkGreen"
        case .darkBlue:
            textureName = "Darkblue"
        case .LGTBI:
            textureName = "LGTBI"
        case .galaxy:
            textureName = "Galaxy"
        case .redBlack:
            textureName = "RedBlack"
        case .festive:
            textureName = "Festive"
        case .pink:
            textureName = "Pink"
        case .sharingan:
            textureName = "Sharingan"
        case .greenPaint:
            textureName = "GreenPaint"
        case .blackPaint:
            textureName = "BlackPaint"
        case .redPaint:
            textureName = "RedPaint"
        case .eclipse:
            textureName = "Eclipse"
        }

        let fileName = "\(basePath)\(textureName).jpg"
        return UIImage(named: fileName)
    }
    
    var eyeColorName: String {
        var textureName: String = ""

        switch self {
        case .brightBlue:
            textureName = "brightblue"
        case .blue:
            textureName = "eyeblue"
        case .darkBrown:
            textureName = "darkbrown"
        case .brown:
            textureName = "eyelightbrown"
        case .green:
            textureName = "eyegreen"
        case .hazel:
            textureName = "eyehazel"
        case .amber:
            textureName = "eyeamber"
        case .amethystGreen:
            textureName = "amethystGreen"
        case .violet:
            textureName = "violet"
        case .azure:
            textureName = "eyeazure"
        case .gray:
            textureName = "gray"
        case .red:
            textureName = "red"
        case .black:
            textureName = "black"
        case .white:
            textureName = "white"
        case .white_pupil:
            textureName = "white_pupil"
        case .black_all:
            textureName = "black_all"
        case .amber_halo:
            textureName = "amber_halo"
        case .yellow_halo:
            textureName = "yellow_halo"
        case .yellow_cat:
            textureName = "yellow_cat"
        case .blue_cat:
            textureName = "blue_cat"
        case .blue_halo:
            textureName = "blue_halo"
        case .green_halo:
            textureName = "green_halo"
        case .green_cat:
            textureName = "green_cat"
        case .blackCornea:
            textureName = "black_all"
        case .yellowGreen:
            textureName = "YellowGreen"
        case .brightGreen:
            textureName = "BrightGreen"
        case .darkGreen:
            textureName = "DarkGreen"
        case .darkBlue:
            textureName = "Darkblue"
        case .LGTBI:
            textureName = "LGTBI"
        case .galaxy:
            textureName = "Galaxy"
        case .redBlack:
            textureName = "RedBlack"
        case .festive:
            textureName = "Festive"
        case .pink:
            textureName = "Pink"
        case .sharingan:
            textureName = "Sharingan"
        case .greenPaint:
            textureName = "GreenPaint"
        case .blackPaint:
            textureName = "BlackPaint"
        case .redPaint:
            textureName = "RedPaint"
        case .eclipse:
            textureName = "Eclipse"
        }

        return textureName
    }
    
    var thumbImage: Image {
        return Image(uiImage: UIImage(named: "Thumb_\(eyeColorName)") ?? UIImage())
    }
}

