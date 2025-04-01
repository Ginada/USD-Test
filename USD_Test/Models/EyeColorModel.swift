//
//  EyeColorModel.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2024-11-18.
//

struct EyeColorModel: AssetStyle, Equatable, Identifiable, Codable {
    
    static func == (lhs: EyeColorModel, rhs: EyeColorModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String
    var type: AssetCategory
    let color: String
    var thumbUrl: String
    var thumbName: String?
    
    var challengeId: String?
    var secondaryChallengeId: String?
    var tags: [ThemeTag]?
    var modelId: String?
    var shared: Bool?
    var theme: Theme?
    var unlockType: UnlockType?
    var pointLevel: PointLevel?
    var unlockAmount: Int?
    var boxUnlockableId: String?
}

extension EyeColorModel {
    static var mockEyeColorStyles: [EyeColorModel]{
        return [
            EyeColorModel(id: "1", type: .eyeColor, color: "blue", thumbUrl: "eye-blue", thumbName: "Thumb_eyebrightblue", challengeId: "1", secondaryChallengeId: "2", tags: [ThemeTag.alien], modelId: "1", shared: true, theme: Theme.cosmicElements, unlockType: .coins, pointLevel: .basic, unlockAmount: 100)
        ]
    }
}
