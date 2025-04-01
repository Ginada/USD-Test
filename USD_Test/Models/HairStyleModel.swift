//
//  HairStyleModel.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2023-12-25.
//

import Foundation


struct HairStyleModel: AssetStyle, Codable, Hashable {
    
    var challengeId: String?
    var secondaryChallengeId: String?
    var tags: [ThemeTag]?
    static func == (lhs: HairStyleModel, rhs: HairStyleModel) -> Bool {
        return lhs.id == rhs.id
    }
    var id: String
    var type: AssetCategory
    let sceneName: String
    let objNames: [String]
    let textures: [String : String]
    let normal: [String : String]?
    var thumbUrl: String
    let baseHair: Bool
    let doubleSided: [String]?
    var thumbName: String?
    var modelId: String?
    var shared: Bool?
    var theme: Theme?
    var unlockType: UnlockType?
    var pointLevel: PointLevel?
    var unlockAmount: Int?
    var placementFile: String?
    var boxUnlockableId: String?
}

extension HairStyleModel {
    
    static var mockHairStyles: [HairStyleModel] {
        return [HairStyle.ponyTail.hairStyleModel, HairStyle.afro.hairStyleModel, HairStyle.mediumFront.hairStyleModel]
    }
}
   
