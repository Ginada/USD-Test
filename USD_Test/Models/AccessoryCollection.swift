//
//  AccessoryCollection.swift
//  Makeover-StyleCreator
//
//  Created by Gina Adamova on 2024-01-30.
//

import SceneKit

enum ApplicationState {
    case accessory
    case placement
    case none
    case deletePlaced
    case deleteAccessory
}

enum ModelBone: String, Codable {
    case head = "Bone-head"
    case neck = "Bone-neck"
    case base = "Bone_base"
    case leftEye = "Bone-eye_left-"
    case rightEye = "Bone-eye_right"
}

enum AccessoryPosition: String, Codable {
    case left
    case right
    case center
}


struct AccessoryCollection: Codable, AssetStyle {
   
    var tags: [ThemeTag]?
    var challengeId: String?
    var secondaryChallengeId: String?
    
    static func == (lhs: AccessoryCollection, rhs: AccessoryCollection) -> Bool {
        return lhs.id == rhs.id &&
            lhs.type == rhs.type &&
            lhs.thumbName == rhs.thumbName
    }
    var paletteId: String {return ""}
    var id: String
    
    var type: AssetCategory
    var theme: Theme?
    
    var thumbName: String?
    var thumbUrl: String
    
    var modelId: String?
    
    var rightPlacement: [AccessoryPlacement] = []
    var centerPlacement: [AccessoryPlacement] = []
    
    var gemIds: [String]
    var shared: Bool?
    var unlockType: UnlockType?
    var pointLevel: PointLevel?
    var unlockAmount: Int?
    var boxUnlockableId: String?
}
