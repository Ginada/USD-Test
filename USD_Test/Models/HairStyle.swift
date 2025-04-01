//
//  HairStyle.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2024-01-09.
//

import Foundation

enum HairStyle: Int, Codable, CaseIterable {
    
    case ponyTail = 1
    case bun = 2
    case short = 3
    case afro = 4
    case largeAfro = 5
    case long = 6
    case shortstraight = 7
    case longFront = 8
    case wayvy = 9
    case tailBack = 10
    case wayvyFront = 11
    case mediumWayvy = 12
    case tailLarge = 13
    case medBob = 14
    case shortBob = 15
    case shortBobBangs = 16
    case shortWayvy = 17
    case mediumStraight = 18
    case mediumFront = 19
    case shortBackBangs = 20
    case sideBuns = 21
    case shortAfro = 22
    case mediumFrontWayvy = 23
    case ponytails = 24
    case largePonyTail = 25
    case ponyTailFront = 26
    case curly_short = 27
    case braid_long = 28
    case braids_short = 29
    case braids_bun = 30
    case braids_8 = 31
    case braids_thin = 32
    case piggy_braids = 33
    case hair_ties = 34
    case hair_wind = 35
    case straight_blowout = 36
    case small_buns = 37
    case wave = 38
    case xlarge_bangs = 39
    case twinned_hair = 40
    case hair_shaved = 41
    case tail_top = 42
    case bunBangs = 43
    //    case dredds = 50
    //    case hair_long_bangs = 59
    //    case curly_bob = 60
    
    var name: String {
        switch self {
        case .shortstraight:
            return "shortstraight"
        case .ponyTail:
            return "ponyTail"
        case .bun:
            return "bun"
        case .afro:
            return "afro"
        case .largeAfro:
            return "largeAfro"
        case .short:
            return "short"
        case .long:
            return "long"
        case .longFront:
            return "longFront"
        case .wayvy:
            return "wayvy"
        case .tailBack:
            return "tailBack"
        case .wayvyFront:
            return "wayvyFront"
        case .mediumWayvy:
            return "mediumWayvy"
        case .tailLarge:
            return "tailLarge"
        case .medBob:
            return "medBob"
        case .shortBob:
            return "shortBob"
        case .shortBobBangs:
            return "shortBobBangs"
        case .shortWayvy:
            return "shortWayvy"
        case .mediumStraight:
            return "mediumStraight"
        case .mediumFront:
            return "mediumFront"
        case .shortBackBangs:
            return "shortBackBangs"
        case .sideBuns:
            return "sideBuns"
        case .shortAfro:
            return "shortAfro"
        case .mediumFrontWayvy:
            return "mediumFrontWayvy"
        case .ponytails:
            return "ponytails"
        case .largePonyTail:
            return "largePonyTail"
        case .ponyTailFront:
            return "ponyTailFront"
        case .curly_short:
            return "curly_short"
            //        case .curly_bob:
            //            return "curly_bob"
        case .braids_short:
            return "braids_short"
        case .braids_bun:
            return "braids_bun"
        case .braid_long:
            return "braid_long"
        case .braids_8:
            return "braids_8"
        case .braids_thin:
            return "braids_thin"
        case .small_buns:
            return "small_buns"
        case .hair_ties:
            return "hair_ties"
        case .piggy_braids:
            return "piggy_braids"
        case .hair_wind:
            return "hair_wind"
        case .straight_blowout:
            return "straight_blowout"
        case .wave:
            return "wave"
        case .xlarge_bangs:
            return "xlarge_bangs"
            //        case .hair_long_bangs:
            //            return "hair_long_bangs"
        case .twinned_hair:
            return "twinned_hair"
        case .hair_shaved:
            return "hair_shaved"
        case .tail_top:
            return "tail_top"
        case .bunBangs:
            return "bunBangs"
            //        case .dredds:
            //            return "dredds"
        }
    }
    
    //
    var sceneName: String {
        switch self {
        case .mediumFront:
            return "medium_front"
        case .bun:
            return "bun"
        case .ponyTail:
            return "ponyTail"
        case .afro:
            return "afro"
        case .small_buns:
            return "hair_small_buns"
        case .hair_ties:
            return "hair_ties"
        case .straight_blowout:
            return "hair_blowout"
        case .piggy_braids:
            return "piggy_tails"
        case .hair_wind:
            return "hair_wind"
        case .tailLarge:
            return "hair_tail_large"
        case .wave:
            return "hair_wave"
        case .mediumFrontWayvy:
            return "hair_medium_wayvy"
        case .xlarge_bangs:
            return "xlarge_hair_buns"
            //        case .hair_long_bangs:
            //            return "hair_bangs"
        case .twinned_hair:
            return "twinned_hair"
        case .hair_shaved:
            return "head_shaved"
        case .tail_top:
            return "tail_top"
            //        case .dredds:
            //            return "dredds"
        case .bunBangs:
            return "bunBangs"
        default:
            return "Makeup_head"
        }
    }
    
    var thumbName: String {
        switch self {
        case .ponyTail:
            return "thumb_ponytail_back"
        case .bun:
            return "icon_hair_bun"
        case .short:
            return "thumb_hairstyle7 unmaked"
        case .afro:
            return "thumb_hairstyle5 unmaked"
        case .largeAfro:
            return "thumb_hairstyle6 unmaked"
        case .long:
            return "icon_hair_longback"
        case .shortstraight:
            return "icon_hair_shortback"
        case .longFront:
            return "thumb_hairstyle09 unmarked"
        case .wayvy:
            return "icon_hair_wayvy_long"
        case .tailBack:
            return "thumb_hairstyle back"
        case .wayvyFront:
            return "thumb_hair_wayvy_side"
        case .mediumWayvy:
            return "thumb_wayvy_medium"
        case .tailLarge:
            return "thumb_hairstyle_tail_large"
        case .medBob:
            return "icon_hair_page"
        case .shortBob:
            return "icon_hair_page_short"
        case .shortBobBangs:
            return "icon_hair_page_bangs"
        case .shortWayvy:
            return "icon_hair_short_wayvy"
        case .mediumStraight:
            return "icon_hair_medium"
        case .mediumFront:
            return "icon_hair_medium_straight"
        case .shortBackBangs:
            return "icon_hair_bangs_back"
        case .sideBuns:
            return "thumb_hair_buns"
        case .shortAfro:
            return "thumb_hairstyle_short"
        case .mediumFrontWayvy:
            return "icon_hair_medium_wayvy"
        case .ponytails:
            return "thumb_hair_side_tails"
        case .largePonyTail:
            return "thumb_hairstyle_tail_large_back"
        case .ponyTailFront:
            return "icon_hair_tail"
        case .curly_short:
            return "icon_hair_short_curly"
        case .braid_long:
            return "thumb_hairstyle_braid_long"
        case .braids_short:
            return "thumb_hairstyle_braids"
        case .braids_bun:
            return "thumb_hairstyle_braids_bun"
        case .braids_8:
            return "thumb_hairstyle_braids_thin"
        case .braids_thin:
            return "thumb_hairstyle_braid_6"
        case .piggy_braids:
            return "thumb_piggy_tails"
        case .hair_ties:
            return "thumb_hairstyle_ties"
        case .hair_wind:
            return "icon_hair_wind"
        case .straight_blowout:
            return "icon_hair_blowout"
        case .small_buns:
            return "thumb_small_buns"
        case .wave:
            return "icon_hair_short_wave"
        case .xlarge_bangs:
            return "icon_hair_large_bang"
        case .twinned_hair:
            return "thumb_hair_twinned"
        case .hair_shaved:
            return "icon_hair_short_shaved"
        case .tail_top:
            return "icon_ponytail_short"
        case .bunBangs:
            return "icon_bun_bangs"
            //        case .dredds:
            //            return ""
            //        case .hair_long_bangs:
            //            return ""
            //        case .curly_bob:
            //            return ""
        }
    }
    
    var geometryName: [String] {
        switch self {
        case .shortstraight:
            return ["hair_short_straight"]
        case .ponyTail:
            return ["tail", "tail_1_top", "tail_1_top2", "tail_holder"]
        case .bun:
            return ["bun_inner", "bun_outer", "bun_outer2"]
        case .afro:
            return ["hair_afro_base"]
        case .largeAfro:
            return ["hair_afro_large"]
        case .short:
            return ["hair_short2"]
        case .long:
            return ["hair_long"]
        case .longFront:
            return ["hair_straight_front"]
        case .wayvy:
            return ["hair_wavy", "hair_wavy_piece"]
        case .tailBack:
            return ["hair_tail_back"]
        case .wayvyFront:
            return ["hair_wavy_half", "hair_wav_side_piece"]
        case .mediumWayvy:
            return ["hair_medium_wave"]
        case .tailLarge:
            return ["hair_tail_large"]
        case .medBob:
            return["hair_bob_med", "hair_bob_piece"]
        case .shortBob:
            return ["hair_bob_short", "hair_bob_short_piece"]
        case .shortBobBangs:
            return ["hair_bob_short", "bob_bangs", "bangs_piece"]
        case .shortWayvy:
            return ["hair_bob_wayvy", "hair_piece_short_wayvy"]
        case .mediumStraight:
            return ["hair_medium", "hair_piece_medium"]
        case .mediumFront:
            return ["hair_medium_front", "hair_piece_medium_front"]
        case .shortBackBangs:
            return ["hair_short_bangs", "bob_bangs_back", "bangs_back_piece"]
        case .sideBuns:
            return ["bun_side_inner"]
        case .shortAfro:
            return ["hair_afro_short"]
        case .mediumFrontWayvy:
            return ["hair_medium_wayvy", "hair_medium_wayvy_piece"]
        case .ponytails:
            return ["ponytail_side"]
        case .largePonyTail:
            return ["hair_large_ponytail"]
        case .ponyTailFront:
            return ["tail_long_front"]
        case .curly_short:
            return ["hair_short_curly", "head_curly_thin_piece"]
            //        case .curly_bob:
            //            return ["hair_bob_curly2", "hair_bob_curly_2_curls"]
        case .braids_short:
            return ["braids"]
        case .braids_bun:
            return ["braids", "braids_bun", "braids_bun_top"]
        case .braid_long:
            return ["braid_long"]
        case .braids_8:
            return ["braids_8", "braids_8_bottom"]
        case .braids_thin:
            return ["braids_thin", "braids_thin_bottom", "braids_piece"]
        case .small_buns:
            return ["hair_small_buns"]
        case .hair_ties:
            return ["hair_ties"]
        case .piggy_braids:
            return ["piggy_tails"]
        case .hair_wind:
            return ["hair_wind", "hair_wind_piece"]
        case .straight_blowout:
            return ["Hair_long_blowout", "hair_blowout_bang","hair_piece_blowout"]
        case .wave:
            return ["hair_fingerwave"]
        case .xlarge_bangs:
            return ["xlarge_bun","large_bangs", "hair_large_bun_outer"]
            //        case .hair_long_bangs:
            //            return ["front_bangs_inner", "back_knot", "front_bangs"]
        case .twinned_hair:
            return ["twinned_tail", "twinned_hair"]
        case .hair_shaved:
            return ["head_shaved"]
        case .tail_top:
            return ["tail_top", "tail_top_bottom"]
        case .bunBangs:
            return ["bun_Bangs", "bunBangs_piece"]
            //        case .dredds:
            //            return ["dredds"]
        }
    }
    
    var baseHair: Bool {
        switch self {
        case .afro, .largeAfro, .short, .shortstraight, .long, .longFront, .wayvy, .tailBack, .wayvyFront, .mediumWayvy, .medBob, .shortBobBangs, .shortBob, .shortWayvy, .mediumStraight, .mediumFront, .shortBackBangs, .shortAfro, .mediumFrontWayvy, .curly_short, .braids_short, .braids_bun, .braids_8, .hair_wind, .braids_thin, .wave, .straight_blowout, .hair_shaved:
            return false
        default:
            return true
        }
    }
    
    func dualLayer(_ model: String) -> Bool {
        switch model {
        case "hair_short_curly", "hair_wind", "large_bangs", "front_bangs_inner", "front_bangs", "tail_top", "tail_top_bottom", "hair_medium_wayvy":
            return true
        default:
            return false
        }
    }
    
    var hairStyleModel: HairStyleModel {
        
        var textures: [String:String] = [:]
        self.geometryName.forEach { geo in
            textures[geo] = textureBaseName(geo)
        }
        
        var normals: [String:String] = [:]
        self.geometryName.forEach { geo in
            normals[geo] = normalTextureFrom(geometry: geo)
        }
        
        let doubleSided = self.geometryName.filter { dualLayer($0)}
        
        return HairStyleModel(id: "\(self.rawValue)", type: .hair, sceneName: sceneName, objNames: geometryName, textures: textures, normal: normals, thumbUrl: "", baseHair: self.baseHair, doubleSided: doubleSided, thumbName: self.thumbName)
    }
    
    func textureBaseName(_ geo: String) -> String {
        switch geo {
        case "hair_medium_wayvy_piece":
            return "hair_streak"
        case "hair_medium_wayvy":
            return "hair_piece_long"
        case "hair_afro_base", "hair_afro_large", "hair_afro_short":
            return "hair_afro_base"
        case "hair_afro_top", "hair_afro_top2":
            return "hair_afro"
            
        case "hair_head", "braids", "braids_8_bottom",
            "braids_thin_bottom":
            return "hair_head"
        case
            "hair_tail_large",
            "hair_wavy"," hair_1", "hair_1_lower", "hair_1_top",
            "tail", "tail_1_top",
            "tail_holder",
            "bun_inner", "bun_outer",
            "hair_long_base", "hair_bangs_1",
            "hair_page", "hair_bangs_2",
            "short_curly_bottom",
            "short_curly_med", "hair_2",
            "bangs", "bangs_2", "bangs3",
            "hair_short_bottom", "hair_short_top", "hair_short2", "hair_short2_bangs",
            "hair_bun", "hair_bun_bangs", "hair_bun_bangs_2", "hair_straight_front",
            "hair_short_straight", "hair_long_wayvy", "hair_wavy_half",
            "hair_bob_med",
            "hair_tail_back", "hair_medium_wave",
            "hair_bob_short", "bob_bangs", "hair_bob_wayvy", "hair_medium",
            "hair_short_bangs",
            "hair_large_ponytail",
            "hair_medium_front", "bob_bangs_back", "bun_side_inner",
            "ponytail_side", "hair_blowout_bang",
            "hair_fingerwave","short_curly_top", "tail_1_top2", "hair_2_top", "hair_2_top_2", "hair_2_top_3", "hair_2_top_4", "bangs2", "bangs_2_2", "hair_large_bun_outer", "twinned_hair", "hair_short_curly_pieces":
            return "hair_piece_long"
            
        case "hair_piece_blowout", "hair_wavy_piece","bun_outer2", "base_hair_outer2", "base_hair_outer", "hair_bun_streak", "hair_bun2", "hair_wav_side_piece",
            "hair_bob_piece", "hair_bob_short_piece", "hair_piece_short_wayvy", "bangs_piece", "hair_piece_medium",
            "bun_side_outer", "hair_piece_medium_front", "bangs_back_piece", "head_curly_thin_piece", "braids_piece", "hair_wind_piece", "front_bangs", "head_shaved", "bunBangs_piece":
            return "hair_streak"
        case "hair_curly", "hair_curly_bangs", "hair_bob_curly_2_curls", "tail_top", "hair_long", "hair_long_bangs":
            return "hair_piece_long"
        case "Hair_long_blowout", "tail_long_front", "hair_bob_curly2", "braids_bun", "braids_bun_top", "braid_long", "braids_8", "hair_small_buns", "piggy_tails", "hair_ties", "hair_wind", "hair_short_curly",
            "braids_thin", "xlarge_bun", "large_bangs", "front_bangs_inner", "back_knot", "twinned_tail", "tail_top_bottom", "dredds",
            "bun_Bangs":
            return "hair_solid"
        default:
            return ""
        }
    }
    
    private func subTextureFrom(geometry: String, color: HairColor?) -> String {
        let textureName: String = color?.textureName ?? ""
        switch geometry {
        case "hair_medium_wayvy_piece":
            return "chain_1_gold"
        case "hair_medium_wayvy":
            return "chain_1_gold"
        case "hair_afro_base", "hair_afro_large", "hair_afro_short":
            return "hair_afro_base_\(textureName)"
        case "hair_afro_top":
            return "hair_afro_\(textureName)"
        case "hair_afro_top2":
            return "hair_afro_\(textureName)"
        case "hair_head", "braids", "braids_8_bottom",
            "braids_thin_bottom":
            return "hair_head_\(textureName)"
        case
            "hair_tail_large",
            "hair_wavy"," hair_1", "hair_1_lower", "hair_1_top",
            "tail", "tail_1_top",
            "tail_holder",
            "bun_inner", "bun_outer",
            "hair_long_base", "hair_bangs_1",
            "hair_page", "hair_bangs_2",
            "short_curly_bottom",
            "short_curly_med", "hair_2",
            "bangs", "bangs_2", "bangs3",
            "hair_short_bottom", "hair_short_top", "hair_short2", "hair_short2_bangs",
            "hair_bun", "hair_bun_bangs", "hair_bun_bangs_2", "hair_straight_front",
            "hair_short_straight", "hair_long_wayvy", "hair_wavy_half",
            "hair_bob_med",
            "hair_tail_back", "hair_medium_wave",
            "hair_bob_short", "bob_bangs", "hair_bob_wayvy", "hair_medium",
            "hair_short_bangs",
            "hair_large_ponytail",
            "hair_medium_front", "bob_bangs_back", "bun_side_inner",
            "ponytail_side", "hair_blowout_bang",
            "hair_fingerwave":
            return "hair_piece_long_\(textureName)"
        case "short_curly_top", "tail_1_top2", "hair_2_top", "hair_2_top_2", "hair_2_top_3", "hair_2_top_4", "bangs2", "bangs_2_2", "hair_large_bun_outer", "twinned_hair", "hair_short_curly_pieces":
            return "hair_piece_long_\(textureName)"
        case "hair_piece_blowout", "hair_wavy_piece","bun_outer2", "base_hair_outer2", "base_hair_outer", "hair_bun_streak", "hair_bun2", "hair_wav_side_piece",
            "hair_bob_piece", "hair_bob_short_piece", "hair_piece_short_wayvy", "bangs_piece", "hair_piece_medium",
            "bun_side_outer", "hair_piece_medium_front", "bangs_back_piece", "head_curly_thin_piece", "braids_piece", "hair_wind_piece", "front_bangs", "head_shaved", "bunBangs_piece":
            return "hair_streak_\(textureName)"
        case "hair_long", "hair_long_bangs":
            return "hair_piece_long_\(textureName)"
        case "hair_curly", "hair_curly_bangs", "hair_bob_curly_2_curls", "tail_top":
            return "hair_piece_long_\(textureName)"
            
        case "Hair_long_blowout", "tail_long_front", "hair_bob_curly2", "braids_bun", "braids_bun_top", "braid_long", "braids_8", "hair_small_buns", "piggy_tails", "hair_ties", "hair_wind", "hair_short_curly",
            "braids_thin", "xlarge_bun", "large_bangs", "front_bangs_inner", "back_knot", "twinned_tail", "tail_top_bottom", "dredds",
            "bun_Bangs":
            return "hair_solid_\(textureName)"
        default:
            return ""
        }
    }
    
    private func normalTextureFrom(geometry: String) -> String {
        switch geometry {
        case "braids_bun", "braids_bun_top",
            "braids_thin":
            return "braids_long_normal"
        case "braids", "dredds":
            return "hair_head_braid_normal"
        case "hair_afro_base", "hair_afro_large", "hair_afro_short":
            return "hair_afro_base_normal"
        case "hair_afro_top":
            return "hair_afro_normal"
        case "hair_afro_top2":
            return "hair_afro_normal"
        case "hair":
            return "hair_head_normal"
        case "hair_tail_large",
            "hair_1", "hair_1_lower",
            "tail", "tail_1_top",
            "tail_holder",
            "bun_inner", "bun_outer",
            "hair_long_base", "hair_bangs_1",
            "hair_long", "hair_long_bangs",
            "hair_page", "hair_bangs_2",
            "short_curly_bottom", "short_curly_med", "hair_short2", "hair_short2_bangs",
            "hair_bun", "hair_bun_bangs", "hair_bun_bangs_2",
            "hair_short_straight", "hair_long_wayvy", "hair_straight_front", "hair_tail_back",
            "hair_bob_med",
            "hair_wavy_half", "hair_medium_wave",
            "hair_bob_short", "bob_bangs",
            "hair_bob_wayvy", "hair_medium",
            "hair_medium_front", "bob_bangs_back", "bun_side_inner", "hair_medium_wayvy", "hair_fingerwave", "hair_large_bun_outer":
            //"hair_short_bottom", "hair_short_top":
            return "hair_piece_long_normal"
        case "hair_1_top", "tail_1_top2", "hair_short_curly":
            return "hair_piece_long_normal"
        case "short_curly_top", "bun_outer2", "base_hair_outer2", "base_hair_outer":
            return "hair_piece_long_normal"
        case "hair_curly":
            return "hair_piece_long_normal"
        case "hair_small_buns", "piggy_tails", "hair_ties", "hair_wind", "large_bangs","xlarge_bun", "twinned_tail", "twinned_hair":
            return "hair_solid_normal"
        default:
            return ""
        }
    }
}
 
