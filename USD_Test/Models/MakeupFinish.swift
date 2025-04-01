//
//  MakeupFinish.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2023-12-26.
//

import UIKit

//
//  MakeupFinish.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2023-12-26.
//

import UIKit
import RealityKit

enum MakeupFinish: String, Codable, CaseIterable {
    
    case matte
    case ultraMatte
    case radiant
    case velvet
    case satin
    case shimmer
    case metallic
    case glitter
    case gloss
    case shinygloss
    case metallicgloss
    case dewy
    case cream
    case glitterFlakes
    case neon
//    case metalFlakes
//    case largeGlitter
    case none
    
    init(from decoder: Decoder) throws {
        guard let value = try? decoder.singleValueContainer().decode(String.self) else {
            self = .none
            return
        }
        self = MakeupFinish(rawValue: value) ?? .none
    }
    
    var metalnessValue: Float {
        switch self {
        default:
            return 1.0
        }
    }
    
    // higher value more roughness (whiter)
    func roughnessValue(type: MakeupType)-> CGFloat {
        if type == .sculptHighlight || type == .sculptShadow || type == .rouge {
            switch self {
            case .satin:
                return 2.0
            case .shimmer:
                return 1.5
            default:
                break
            }
        }
        if type == .lips || type == .lipliner {
            switch self {
            case .metallicgloss:
                return 0.6
            case .shinygloss:
                return 0.7
            case .gloss:
                return 1.0
            case .satin:
                return 3.0
            case .velvet:
                return 4.0
            case .shimmer:
                return 5.5
            case .metallic:
                return 4.0
            default:
                return 1.0
            }
        }
        if type == .foundation || type == .paint {
            switch self {
            case .satin:
                return 1.0
            default:
                break
            }
        }
        
        switch self {
        case .metallicgloss:
            return 0.6
        case .shimmer:
            return 1.5
        case .satin:
            return 2.0
        case .velvet, .neon:
            return 2.8
        case .metallic:
            return 1.5
        case .glitter:
            return 0.8
        default:
            return 1.0
        }
    }
    
    func metalness(type: MakeupType) -> UIColor {
        if type == .glitter {
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        if type == .sculptHighlight || type == .sculptShadow || type == .rouge {
            switch self {
            case .glitterFlakes:
                return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case .shimmer:
                return #colorLiteral(red: 0.5479819775, green: 0.5496441126, blue: 0.5701715946, alpha: 1)
            case .satin:
                return #colorLiteral(red: 0.5863415003, green: 0.5917546153, blue: 0.6053217649, alpha: 1)
            default:
                break
            }
        }
        if type == .foundation || type == .paint {
            switch self {
            case .glitterFlakes:
                return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case .satin:
                return #colorLiteral(red: 0.3847212791, green: 0.3882758319, blue: 0.3971749544, alpha: 1)
            case .matte:
                return #colorLiteral(red: 0.5661910176, green: 0.5714184046, blue: 0.5845189095, alpha: 1)
            case .cream:
                return #colorLiteral(red: 0.2634936869, green: 0.2702680826, blue: 0.2700927258, alpha: 1)
            case .velvet:
                return #colorLiteral(red: 0.3987075388, green: 0.4051175714, blue: 0.4092781544, alpha: 1)
            case .metallic:
                return #colorLiteral(red: 0.9193275571, green: 0.9383094311, blue: 0.9586185813, alpha: 1)
            case .metallicgloss:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            default:
                break
            }
        }
        if type == .lashes {
            switch self {
            case .metallic:
                return #colorLiteral(red: 0.9221640229, green: 0.9437945485, blue: 0.9182729721, alpha: 1)
            default:
                break
            }
        }
        if type == .lips || type == .lipliner {
            switch self {
            case .glitterFlakes:
                return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case .metallicgloss:
                return #colorLiteral(red: 0.7894050479, green: 0.796690166, blue: 0.8149585128, alpha: 1)
            case .shinygloss:
                return #colorLiteral(red: 0.6091015935, green: 0.6119235158, blue: 0.6188104749, alpha: 1)
            case .shimmer:
                return #colorLiteral(red: 0.6091015935, green: 0.6119235158, blue: 0.6188104749, alpha: 1)
            case .matte:
                return #colorLiteral(red: 0.5801571608, green: 0.5767116547, blue: 0.5828078389, alpha: 1)
            case .gloss:
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case .satin:
                return #colorLiteral(red: 0.09923999757, green: 0.09970698506, blue: 0.1008211449, alpha: 1)
            case .metallic:
                return #colorLiteral(red: 0.7894050479, green: 0.796690166, blue: 0.8149585128, alpha: 1)
            case .velvet:
                return #colorLiteral(red: 0.2947512865, green: 0.2994920611, blue: 0.3025653958, alpha: 1)
            default:
                return #colorLiteral(red: 0.637341857, green: 0.6335557699, blue: 0.6402539015, alpha: 1)
            }
        }
        switch self {
        case .glitterFlakes:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case .satin:
            return #colorLiteral(red: 0.7913662195, green: 0.8040816784, blue: 0.8123491406, alpha: 1)
                //UIImage(named: "art.scnassets/Makeup/eye_metalness_sparcle.jpg", in: Bundle.init(for: GameViewController.self), compatibleWith: nil)!
        case .shimmer:
            return #colorLiteral(red: 0.8354161382, green: 0.8488389254, blue: 0.8575671315, alpha: 1)
        case .metallic:
            return #colorLiteral(red: 0.6882647872, green: 0.6841754317, blue: 0.6914095283, alpha: 1)
        case .metallicgloss:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            return UIImage(named: "art.scnassets/Makeup/eye_sparcle.jpg", in: Bundle.init(for: GameViewController.self), compatibleWith: nil)!
        case .glitter:
            return #colorLiteral(red: 0.8978825808, green: 0.8925452828, blue: 0.9019854069, alpha: 1)
           // return UIImage(named: "art.scnassets/Makeup/eye_sparcle.jpg", in: Bundle.init(for: GameViewController.self), compatibleWith: nil)!
        case .velvet:
            return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        default:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    
    func rougness(type: MakeupType)-> Any {
        if type == .glitter {
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        if type == .sculptHighlight || type == .sculptShadow || type == .rouge {
            switch self {
            case .satin, .velvet, .shimmer, .metallic:
                return "eyeshadow_roughness_medium"
            default:
                break
            }
        }
        
        if type == .lips || type == .lipliner {
            switch self {
            case .glitterFlakes:
                return "glitter_flakes_roughness"
            case .shinygloss, .metallicgloss:
                return #colorLiteral(red: 0.169983089, green: 0.1721585691, blue: 0.172080338, alpha: 1)
            case .gloss:
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case .satin, .velvet, .metallic, .shimmer:
                return "face_roughness"
            default:
                return #colorLiteral(red: 0.822939992, green: 0.8180488348, blue: 0.8267002702, alpha: 1)
            }
        }
        if type == .foundation || type == .paint {
            switch self {
            case .glitterFlakes:
                return "glitter_flakes_roughness"
            case .matte:
                return #colorLiteral(red: 0.7173742652, green: 0.7356892228, blue: 0.7602406144, alpha: 1)
            case .ultraMatte:
                return #colorLiteral(red: 0.8386229277, green: 0.860032618, blue: 0.8887346387, alpha: 1)
            case .gloss:
                return #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
            case .satin:
                return #colorLiteral(red: 0.548446238, green: 0.5535100698, blue: 0.5661998391, alpha: 1)
            case .cream:
                return #colorLiteral(red: 0.4783070087, green: 0.4905991554, blue: 0.4902892113, alpha: 1)
            case .dewy:
                return #colorLiteral(red: 0.4605873227, green: 0.47971946, blue: 0.4843109846, alpha: 1)
            case.metallic:
                return #colorLiteral(red: 0.3116222024, green: 0.3205000758, blue: 0.3236574531, alpha: 1)
            case.metallicgloss:
                return #colorLiteral(red: 0.1581508219, green: 0.164721638, blue: 0.1662917137, alpha: 1)
            case .velvet:
                 return #colorLiteral(red: 0.7945500016, green: 0.8109562993, blue: 0.8285078406, alpha: 1)
//                    UIImage(named: "art.scnassets/v_1/face_roughness.jpg", in: Bundle.init(for: GameViewController.self), compatibleWith: nil)!
            default:
                break
            }
        }
        switch self {
        case .glitterFlakes:
            return "glitter_flakes_roughness"
        case .dewy:
            return #colorLiteral(red: 0.4474017024, green: 0.4648455977, blue: 0.4644528031, alpha: 1)
        case .shimmer, .velvet, .satin:
            return "eyeshadow_roughness_shiny"
        case .metallic:
            return #colorLiteral(red: 0.2064524889, green: 0.2117617428, blue: 0.2116222084, alpha: 1)
        case .glitter:
            return #colorLiteral(red: 0.06901208311, green: 0.06903171539, blue: 0.06900952011, alpha: 1)
        case .gloss:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .matte:
            return #colorLiteral(red: 0.5621820092, green: 0.5588434339, blue: 0.5647504926, alpha: 1)
        default:
            return #colorLiteral(red: 0.7632862329, green: 0.7587502599, blue: 0.7667738795, alpha: 1)
        }
    }
    
    var gloss: Any? {
         switch self {
         case .shimmer:
            return #colorLiteral(red: 0.8273842931, green: 0.8224667907, blue: 0.8311650157, alpha: 1)
        case .metallic:
            return #colorLiteral(red: 0.8273842931, green: 0.8224667907, blue: 0.8311650157, alpha: 1)
        case .satin:
            return #colorLiteral(red: 0.7252816558, green: 0.7209720612, blue: 0.728595674, alpha: 1)
         default:
            return nil
        }
    }
    
    var emission: Float? {
        switch self {
        case .neon:
            return 0.2
        case .glitterFlakes:
            return 0
        default:
            return nil
        }
    }
    
    func normalValue(type: MakeupType) -> Float {
        if type == .glitter {
            return 1.0
        }
        if type == .lips {
            switch self {
            case .metallic:
                return 0.5
            default:
                break
            }
        }
        if type == .foundation || type == .sculptShadow || type == .sculptHighlight, type == .rouge || type == .paint {
            switch self {
            case .satin, .velvet, .shimmer:
                return 0.5
            case .matte:
                return 0.4
            case .dewy:
                return 0.3
            default:
                break
            }
        }
        switch self {
        case .matte:
            return 0.7
        case .metallic:
            return 0.7
        case .glitter:
            return 0.7
        case .shimmer:
            return 0.8
        case .satin:
            return 0.7
        case .velvet:
            return 0.5
        default:
            return 1.0
        }
    }
    
    func normal(type: MakeupType, dimples: Bool) -> String {
       
        if type == .glitter {
            return "glitter_nmp"
        }
        if type == .foundation || type == .sculptHighlight || type == .sculptShadow || type == .rouge || type == .paint{
            switch self {
            case .satin, .metallic, .shimmer, .velvet:
                if dimples {
                    return "makeup_normal_dimples"
                }
                return "makeup_normal"
            default:
                break
            }
        }
         switch self {
         case .matte:
             if dimples {
                 return "makeup_normal_dimples"
             }
            return "makeup_normal"
         case .glitterFlakes:
             return "glitter_flakes_normal"
         case .shimmer, .satin, .velvet:
            if type == .lips || type == .lipliner {
                if dimples {
                    return "makeup_normal_dimples"
                }
                return "makeup_normal"
            }
            return "skin_normal2"
         case .metallic, .glitter:
            if type == .lips || type == .lipliner {
                if dimples {
                    return "makeup_normal_dimples"
                }
                return "makeup_normal"
            }
            if type == .eyeshadow || type == .eyeliner {
                return "eye_sparcle_normal"
            }
            return "skin_normal2"
         default:
             if dimples {
                 return "makeup_normal_dimples"
             }
            return "makeup_normal"
        }
    }
    
    func repeatCountMetalness(type: MakeupType) -> (Float, Float) {
        switch self{
        case .glitter:
             return(5,5)
        case .glitterFlakes:
            return(7,7)
        case .metallic:
            return(4,4)
        default:
            return (1, 1)
        }
    }
    
    func repeatCountNormal(type: MakeupType) -> (Float, Float) {
        if type == .glitter {
             return(30,30)
        }
        if type == .sculptHighlight || type == .sculptShadow || type == .rouge {
            switch self {
                default:
                return (1,1)
            }
        }
        if type == .foundation || type == .paint {
                      switch self {
                      case .glitterFlakes:
                          return(7,7)
                      case .satin:
                         return (1,1)
                      default:
                         return (1,1)
                      }
                  }
           if type == .lips || type == .lipliner {
               switch self {
               case .glitterFlakes:
                   return(7,7)
               default:
                     return (1, 1)
               }
           }
           switch self{
           case .glitterFlakes:
                return(7,7)
           case .shimmer, .satin:
               return (6, 8)
           case .velvet:
               return (12, 14)
           case .metallic, .glitter:
               return(8, 8)
           default:
               return (1, 1)
           }
       }
    
    func repeatCount(type: MakeupType) -> (Float, Float) {
        if type == .foundation || type == .paint {
                   switch self {
                   case .glitterFlakes:
                       return(7,7)
                   case .satin:
                      return (1,1)
                   default:
                       break
                   }
               }
        if type == .lips || type == .lipliner {
            switch self {
            case .glitterFlakes:
                return(7,7)
            default:
                return (1, 1)
            }
        }
        switch self{
        case .glitterFlakes:
             return(7,7)
        case .shimmer, .satin:
            return (4, 8)
        case .velvet:
            return (12, 14)
        case .metallic, .glitter:
            return(8, 8)
        default:
            return (1, 1)
        }
    }
    
    var lighterPercentage: Float {
        switch self {
        case .shinygloss, .metallicgloss:
            return 40
        case .glitter:
            return 40
         case .shimmer:
            return 60.0
        case .metallic:
            return 30.0
        case .satin:
            return 40.0
        case .velvet:
            return 30.0
         default:
            return 0
        }
    }
    
    func glitterOcclusion(_ type: MakeupType)-> String? {
        if type == .glitter {
            return "Art.scnassets/textures/makeup/glitter_occlusion.jpg"
        }
        return nil
    }
    
    func overlayImage(_ type: MakeupType)-> String? {
        if type == .lips {
            switch self {
            case .shimmer:
                return "color_lips_shimmer_overlay"
            case .metallic:
                return "color_lips_metallic_overlay"
            case .satin:
                return "color_lips_satin_overlay"
            case .velvet:
                return "color_lips_velvet_overlay"
            case .gloss:
                return "color_glossy_overlay"
            case .matte:
                return "color_lips_matte_overlay"
            case .metallicgloss:
                return "color_metallicgloss_overlay"
            case .shinygloss:
                return "color_shinygloss_overlay"
            default:
                break
            }
        }
        switch self {
        case .dewy:
            return "color_dewy_overlay"
        case .shimmer:
            return "color_shimmer_overlay"
        case .metallic:
            return "color_metallic_overlay"
        case .satin:
            return "color_satin_overlay"
        case .velvet:
            return "color_velvet_overlay"
        case .gloss:
            return "color_glossy_overlay"
        case .matte:
            return "color_matte_overlay"
        case .glitter:
            return "color_glitter_overlay"
        case .glitterFlakes:
            return "color_glitter_flakes_overlay"
        case .metallicgloss:
            return "color_metallicgloss_overlay"
        case .shinygloss:
            return "color_shinygloss_overlay"
        default:
            return nil
        }
    }
}
