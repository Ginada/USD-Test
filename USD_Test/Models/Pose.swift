//
//  Pose.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2024-02-05.
//

import Foundation

enum BasicPose: String, CaseIterable {
    
    case turn
    case tilt
    case nod
    case lookSide
    case lookUp
    case blink
    case smile
    case pout
    
    var icon: String {
        switch self {
        case .turn:
            return "pose_turn_ico"
        case .tilt:
            return "pose_tilt_ico"
        case .nod:
            return "pose_nod_ico"
        case .lookSide:
            return "pose_look_side_ico"
        case .lookUp:
            return "pose_look_up_ico"
        case .blink:
            return "pose_blink_ico"
        case .smile:
            return "pose_smile_ico"
        case .pout:
            return "pose_pout_ico"
        }
    }
    
    var faceShape: FaceShape? {
        switch self {
        case .turn:
            return nil
        case .tilt:
            return nil
        case .nod:
            return nil
        case .lookSide:
            return nil
        case .lookUp:
            return nil
        case .blink:
            return .blink
        case .smile:
            return .smile
        case .pout:
            return .pout
        }
    }
    
    var minValue: Double {
            switch self {
            case .turn:
                return -1
            case .tilt:
                return -1
            case .nod:
                return -1
            case .lookSide:
                return -1
            case .lookUp:
                return -1
            case .blink:
                return 0
            case .smile:
                return 0
            case .pout:
                return 0
            }
        }
    
    var maxValue: Double {
            switch self {
            case .turn:
                return 1
            case .tilt:
                return 1
            case .nod:
                return 1
            case .lookSide:
                return 1
            case .lookUp:
                return 1
            case .blink:
                return 1
            case .smile:
                return 1
            case .pout:
                return 1
            }
        }
}

enum Pose: CaseIterable {
    
    case poseTiltLeft
    case poseTiltRight
    case poseLookBack
    case posePout
    case defaultPose
    
    var iconName: String {
        switch self {
        case .poseTiltLeft:
            return "pose_1_ico"
        case .poseTiltRight:
            return "pose_1_ico"
        case .poseLookBack:
            return "pose_1_ico"
        case .posePout:
            return "pose_1_ico"
        case .defaultPose:
            return "pose_1_ico"
        }
    }
    
    var rotation: Double {
        switch self {
        case .poseTiltLeft:
            return -0.22488566
        case .defaultPose:
            return 0
        case .poseTiltRight:
            return -0.3395172
        case .poseLookBack:
            return 0.25656357
        case .posePout:
            return 0.11047934
        }
    }
    
    static var inbetweenPose: [BasicPose: Double] {
        return  [
            .smile: 0.5,
            .turn: 0.2,
            .lookSide: -0.3,
            .lookUp: 0.0,
            .tilt: 0.2,
            .nod: 0,
            .blink: 0.0,
            .pout: 0.2
        ]
    }
    
    static var IdlePose1: [BasicPose: Double] {
        return  [
            .smile: 0.3,
            .turn: 0,
            .lookSide: 0.0,
            .lookUp: 0.0,
            .tilt: -0.2,
            .nod: 0,
            .blink: 0.0,
            .pout: 0.0
        ]
    }
    
    static var IdlePose2: [BasicPose: Double] {
        return  [
            .smile: 0.2,
            .turn: 0,
            .lookSide: 0.1,
            .lookUp: 0.0,
            .tilt: 0,
            .nod: -0.1,
            .blink: 0.0,
            .pout: 0.0
        ]
    }
    
    static var IdleBlinkPose: [BasicPose: Double] {
        return  [
            .smile: 0.0,
            .turn: 0,
            .lookSide: 0.0,
            .lookUp: 0.0,
            .tilt: 0.0,
            .nod: 0,
            .blink: 1.0,
            .pout: 0.0
        ]
    }
    
    
    var basicPoseValue: [BasicPose: Double] {
        switch self {
        case .poseTiltLeft:
            return [
                .smile: 0.5,
                .turn: 0.05,
                .lookSide: -0.7,
                .lookUp: 0.0,
                .tilt: 0.45,
                .nod: 0.3,
                .blink: 0.0,
                .pout: 0.45
            ]
        case .defaultPose:
            return [
                .smile: 0,
                .turn: 0.05,
                .lookSide: 0,
                .lookUp: 0.0,
                .tilt: 0,
                .nod: 0,
                .blink: 0.0,
                .pout: 0
            ]
        case .poseTiltRight:
            return [
                .lookUp: -0.05,
                .nod: 0.3,
                .turn: -0.65,
                .lookSide: -1.0,
                .smile: 0.0,
                .pout: 0.0,
                .tilt: -0.05,
                .blink: 0.0
            ]
        case .poseLookBack:
            return [
                .lookUp: 0.15,
                .nod: 0.3,
                .turn: 0.35,
                .lookSide: 0.8,
                .smile: 0.4,
                .pout: 0.0,
                .tilt: -0.65,
                .blink: 0.1
            ]
        case .posePout:
            return [
                .tilt: -0.15,
                .lookUp: 0.05,
                .blink: 0.0,
                .nod: 0.1,
                .lookSide: 0.1,
                .pout: 0.8,
                .turn: 0.25,
                .smile: 0.0
            ]

        }
    }
}

public enum FaceShape: Int, Codable, CaseIterable {
    case noseTipUp = 0
    case noseTipThick
    case nostrilsThick
    case nostrilsInner
    case nostrilsUpper
    case nostrilsLower
    case noseUpperWide
    case noseBumb
    case nosetipLong
    case noseSize
    
    case lipsThinLower
    case lipsThinUpper
    case lipsHeart
    case lipsWide
    case lipsLarge
    case chinShort
    case front
    
    case jawOval
    case jawRound
    case jawSquare
    case eyeSize
    case eyeHorizontal
    case eyeMonolid
    case eyelidPuff
    case eyesDroopy
    case eyeShapeRound
    case eyesRound
    case browsOutLower
    case browsInLower
    case smile
    case blink
    case pout
    case frown
    case jawOpen
    case squareChin
    
    var browIndex: Int? {
        switch self {
        case .eyeSize:
            return 0
        case .eyeHorizontal:
            return 1
        case .browsOutLower:
           return 2
        case .browsInLower:
           return 3
        default:
            return nil
        }
    }
    
    var eyelashesIndex: Int? {
        switch self {
        case .eyeSize:
            return 0
        case .eyeHorizontal:
            return 1
        case .eyeMonolid:
            return 2
        case .eyesDroopy:
            return 3
        case .eyeShapeRound:
            return 4
        case .blink:
            return 5
        default:
            return nil
        }
    }
}
