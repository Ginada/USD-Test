//
//  BodyColor.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2023-12-23.
//

import UIKit


public enum BodyColor: Int, Codable {
    
    case brightest = 1
    case brightPink = 2
    case tan = 3 //"color_tanned"
    
    case darkBronze = 4 // "color_tanned",
    case olive = 5
    case darkMedium = 6 // "color_teal"
    case chokolate = 7 // "color_darkBronze"
    case darkChoclate = 8 // "color_chokolate"
    case teal = 9
    
    case noirLight = 10
    case noirMed = 11
    case noir = 12 // "color_chokolate",
    case noirFull = 13 // "color_noirDarkFull"
    // "color_darkChokolate"
    
    // "color_noirLight",
    case noirDark = 14 // "color_noirMedium",
    case noirDarkFull = 15 //  "color_superNoir"
    case noirSuper = 16 // "color_noir"
    //  "color_noirFull",
    //  "color_noirDark",
    
    
    // Unlockables
    case Blue = 17
    case Red = 18
    case Green = 19
    case Yellow = 20
    case Purple = 21
    case Porclain = 22
    case Darkest = 23
    case Pink = 24
    case Aqua = 25
    
    public var faceTexture: UIImage? {
        let basePath = "Art.scnassets/textures/head/Head_"
        let textureName: String
        
        switch self {
        case .brightest:
            textureName = "brightest"
        case .brightPink:
            textureName = "bright"
        case .tan:
            textureName = "medium"
        case .darkBronze:
            textureName = "BaseColor"
        case .chokolate:
            textureName = "dark"
        case .darkChoclate:
            textureName = "darkChoclate"
        case .noir:
            textureName = "noir"
        case .olive:
            textureName = "olive"
        case .darkMedium:
            textureName = "darkMedium"
        case .noirLight:
            textureName = "noirLight"
        case .noirDark:
            textureName = "noirDark"
        case .noirSuper:
            textureName = "superNoir"
        case .teal:
            textureName = "teal"
        case .noirMed:
            textureName = "noirMed"
        case .noirFull:
            textureName = "noirFull"
        case .noirDarkFull:
            textureName = "noirDarkFull"
        case .Blue:
            textureName = "Blue"
        case .Red:
            textureName = "Red"
        case .Green:
            textureName = "Green"
        case .Yellow:
            textureName = "Yellow"
        case .Purple:
            textureName = "Purple"
        case .Pink:
            textureName = "pink"
        case .Aqua:
            textureName = "aqua"
        case .Porclain:
            textureName = "Porclain"
        case .Darkest:
            textureName = "Darkest"
        }
        
        let fileName = "\(basePath)\(textureName).jpg"
        return UIImage(named: fileName, in: Bundle.main, compatibleWith: nil)
    }
    
    public var texture: String {
        var textureName: String
        
        switch self {
        case .brightest:
            textureName = "brightest"
        case .brightPink:
            textureName = "bright"
        case .tan:
            textureName = "medium"
        case .darkBronze:
            textureName = "BaseColor"
        case .chokolate:
            textureName = "dark"
        case .darkChoclate:
            textureName = "darkChoclate"
        case .noir:
            textureName = "noir"
        case .olive:
            textureName = "olive"
        case .darkMedium:
            textureName = "darkMedium"
        case .noirLight:
            textureName = "noirLight"
        case .noirDark:
            textureName = "noirDark"
        case .noirSuper:
            textureName = "superNoir"
        case .teal:
            textureName = "teal"
        case .noirMed:
            textureName = "noirMed"
        case .noirFull:
            textureName = "noirFull"
        case .noirDarkFull:
            textureName = "noirDarkFull"
        case .Blue:
            textureName = "Blue"
        case .Red:
            textureName = "Red"
        case .Green:
            textureName = "Green"
        case .Yellow:
            textureName = "Yellow"
        case .Purple:
            textureName = "Purple"
        case .Pink:
            textureName = "pink"
        case .Aqua:
            textureName = "aqua"
        case .Porclain:
            textureName = "Porclain"
        case .Darkest:
            textureName = "Darkest"
        }
        
        return textureName
    }
    var roughnessTexture: UIImage? {
        return UIImage(named: "Art.scnassets/textures/head/Head_Roughness.jpg")
    }
    
    var thumbnail: UIImage? {
        switch self {
        case .brightest:
            return UIImage(named: "thumb_color_brightest")
        case .brightPink:
            return UIImage(named: "thumb_color_brightPink")
        case .tan:
            return UIImage(named: "thumb_color_tan")
        case .darkBronze:
            return UIImage(named: "thumb_color_darkBronze")
        case .olive:
            return UIImage(named: "thumb_color_olive")
        case .darkMedium:
            return UIImage(named: "thumb_color_chokolate")
        case .chokolate:
            return UIImage(named: "thumb_color_chokolate")
        case .darkChoclate:
            return UIImage(named: "thumb_color_darkChokolate")
        case .teal:
            return UIImage(named: "thumb_color_teal")
        case .noirLight:
            return UIImage(named: "thumb_color_noirLight")
        case .noirMed:
            return UIImage(named: "thumb_color_noirMedium")
        case .noir:
            return UIImage(named: "thumb_color_noir")
        case .noirFull:
            return UIImage(named: "thumb_color_noirFull")
        case .noirDark:
            return UIImage(named: "thumb_color_noirDark")
        case .noirDarkFull:
            return UIImage(named: "thumb_color_noirDarkFull")
        case .noirSuper:
            return UIImage(named: "thumb_color_superNoir")
        case .Blue:
            return UIImage(named: "thumb_color_Blue")
        case .Red:
            return UIImage(named: "thumb_color_Red")
        case .Green:
            return UIImage(named: "thumb_color_Green")
        case .Yellow:
            return UIImage(named: "thumb_color_Yellow")
        case .Purple:
            return UIImage(named: "thumb_color_Purple")
        case .Pink:
            return UIImage(named: "thumb_color_pink")
        case .Aqua:
            return UIImage(named: "thumb_color_aqua")
        case .Porclain:
            return UIImage(named: "thumb_color_Porclain")
        case .Darkest:
            return UIImage(named: "thumb_color_Darkest")
            
        }
    }

}
