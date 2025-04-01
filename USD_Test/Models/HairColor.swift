//
//  HairColor.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2023-12-25.
//

import Foundation
import SwiftUI

public enum HairColor: Int, Hashable, Codable {
    
    case lightBlond = 1
    case blond = 2
    case darkBlond = 3
    case lightBrown = 4
    case brown = 5
    case red = 6
    case black = 7
    case blond_med = 8
    case redChesnut = 9
    case blond_mix = 10
    case pink = 11
    case blue = 12
    case purple = 13
    case yellow = 14
    case squirrelBlond = 15
    case squirrelPink = 16
    case blondeSilver = 17
    case green = 18
    case mint = 19
    case dark_purple = 20
    case babyPink = 21
    case silverOmbre = 22
    case white = 23
    case purple_pink = 24
    case light_pink_blond = 25
    case squirrel_black_pink = 26
    case squirrel_pink_black = 27
    case redScarlet = 28
    case red_bright = 29
    case orange = 30
    case blue_dark = 31
    case pink_med = 32
    case redMed = 33
    case green_dark = 34
    case blue_med = 35
    case dark_pink = 36
    case green_med = 37
    case rainbow = 38
    case purple_dark = 39
    case med_blonde = 40
    case multi2 = 41
    case multi = 42
    
    
    var textureName: String {
        switch self {
        case .brown:
            return "brown"
        case .blond:
            return "blonde"
        case .black:
            return "black"
        case .darkBlond:
            return "blonde_dark"
        case .lightBrown:
            return "brown_light"
        case .blond_med:
            return "blonde_med"
        case .blond_mix:
            return "blonde_mix"
        case .lightBlond:
            return "blonde_light"
        case .red:
            return "red"
        case .redChesnut:
            return "red_chesnut"
        case .pink:
            return "pink"
        case .blue:
            return "blue"
        case .purple:
            return "purple"
        case .yellow:
            return "yellow"
        case .squirrelBlond:
            return "squirrel_blond"
        case .squirrelPink:
            return "squirrel_pink"
        case .blondeSilver:
            return "blonde_silver"
        case .green:
            return "green"
        case .mint:
            return "mint"
        case .dark_purple:
            return "dark_purple"
        case .babyPink:
            return "babyPink"
        case .silverOmbre:
            return "silverOmbre"
        case .white:
            return "white"
        case .purple_pink:
            return "purple_pink"
        case .light_pink_blond:
            return "light_pink_blond"
        case .squirrel_black_pink:
            return "squirrel_black_pink"
        case .squirrel_pink_black:
            return "squirrel_pink_black"
        case .redScarlet:
            return "redScarlet"
        case .red_bright:
            return "red_bright"
        case .orange:
            return "orange"
        case .blue_dark:
            return "blue_dark"
        case .pink_med:
            return "pink_med"
        case .redMed:
            return "redMed"
        case .green_dark:
            return "green_dark"
        case .blue_med:
            return "blue_med"
        case .dark_pink:
            return "dark_pink"
        case .green_med:
            return "green_med"
        case .rainbow:
            return "rainbow"
        case .purple_dark:
            return "purple_dark"
        case .med_blonde:
            return "med_blonde"
        case .multi2:
            return "multi"
        case .multi:
            return "multi"
        }
    }
}

extension HairColor {
    static var mockData: [HairColor] = [.lightBlond, .darkBlond, .lightBrown, .brown, .black, .red_bright, .blue, .squirrel_black_pink, .purple_pink]
    
//    var bubbleContent: BubbleContent {
//        // Use `textureName` as both the image suffix and the unique ID
//        return BubbleContent(color: .clear,
//                             image: "thumb_hair_" + textureName,
//                             id: textureName)
//    }
    
    var thumbImage: Image {
        return Image(uiImage: UIImage(named: "thumb_hair_" + textureName) ?? UIImage())
    }
}
