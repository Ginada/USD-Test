//
//  ClothingModel.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2024-01-13.
//

import SceneKit

public struct AssetModel: AssetStyle, Codable, Hashable {
    
    public var challengeId: String?
    public var secondaryChallengeId: String?
    public static func == (lhs: AssetModel, rhs: AssetModel) -> Bool {
        return lhs.id == rhs.id
    }
    public var id: String
    public var type: AssetCategory
    public var thumbName: String?
    public var thumbUrl: String
    public var modelId: String?
    public let sceneName: String
    public let objNames: [String]
    public let textures: [String : String]
    public let opacity: [String : Float]?
    public let roughness: [String : Float]?
    public let metalness: [String : Float]?
    public let normal: [String : String]?
    public let doubleSided: [String]?
    public var scale: Float? = nil
    public var theme: Theme?
    public var tags: [ThemeTag]?
    public var show: Bool?
    public var shared: Bool?
    public var unlockType: UnlockType?
    public var pointLevel: PointLevel?
    public var unlockAmount: Int?
    public var boxUnlockableId: String?
}

extension AssetModel {
    
    static var mockClothingData: [AssetModel] {
        let clothes1 = AssetModel(id: "14", type: .fashion, thumbName: "thumb_clothing_3", thumbUrl: "", sceneName: "shirt_1", objNames: ["shirt_1"], textures: ["shirt_1": "shirt_1_1001.jpg"], opacity: nil, roughness: ["shirt_1": 0.8], metalness: nil, normal: [:], doubleSided: nil, unlockType: .stars, pointLevel: .basic, unlockAmount: 3)
        let clothes2 = AssetModel(id: "24", type: .fashion, thumbName: "thumb_clothing_2", thumbUrl: "", sceneName: "shirt_1", objNames: ["shirt_1"], textures: ["shirt_1": "shirt_1_1002.jpg"], opacity: nil, roughness: ["shirt_1": 0.8], metalness: nil, normal: [:], doubleSided: nil, unlockType: .likes, pointLevel: .premium, unlockAmount: 10)
        let clothes3 = AssetModel(id: "34", type: .fashion, thumbName: "thumb_clothing_35", thumbUrl: "", sceneName: "shirt_1", objNames: ["shirt_1"], textures: ["shirt_1": "shirt_1_1003.jpg"], opacity: nil, roughness: ["shirt_1": 0.8], metalness: nil, normal: [:], doubleSided: nil, unlockType: .coins, pointLevel: .exclusive, unlockAmount: 15)
        let clothes4 = AssetModel(id: "44", type: .fashion, thumbName: "thumb_clothing_27", thumbUrl: "", sceneName: "v_top", objNames: ["v_top"], textures: ["v_top": "v-top_1001.jpg"], opacity: nil, roughness: ["v_top": 0.8], metalness: nil, normal: ["v_top":"v-top_normal.jpg"], doubleSided: nil, unlockType: .ad, pointLevel: .basic, unlockAmount: 2)
        let clothes5 = AssetModel(id: "54", type: .fashion, thumbName: "thumb_clothing_56", thumbUrl: "", sceneName: "v_top", objNames: ["v_top"], textures: ["v_top": "v-top_1002.jpg"], opacity: nil, roughness: ["v_top": 0.8], metalness: nil, normal: ["v_top":"v-top_normal.jpg"], doubleSided: nil, unlockType: .diamonds, pointLevel: .premium, unlockAmount: 20)
        
        return [clothes1, clothes2, clothes3, clothes4, clothes5]
    }

    static var mockGemsData: [AssetModel] {
        let stone1 = AssetModel(id: "1", type: .gems, thumbName: "thumb_crystal_36", thumbUrl: "", sceneName: "bead_plane_large", objNames: ["bead_plane_large"], textures: ["bead_plane_large": "bead_4_blue.png"], opacity: nil, roughness: ["bead_plane_large": 0.2], metalness: ["bead_plane_large": 0.2], normal: ["bead_plane_large": "bead_4_nmp.jpg"], doubleSided: nil, scale: 1, tags: [ThemeTag.clouds,ThemeTag.fairy], unlockType: UnlockType.coins, pointLevel: .basic, unlockAmount: 1)
        let stone2 = AssetModel(id: "2", type: .gems, thumbName: "thumb_crystal_26", thumbUrl: "", sceneName: "bead_plane_large", objNames: ["bead_plane_large"], textures: ["bead_plane_large": "bead3_purple.png"], opacity: nil, roughness: ["bead_plane_large": 0.2], metalness: ["bead_plane_large": 0.2], normal: ["bead_plane_large": "bead3_nmp.jpg"], doubleSided: nil, scale: 1, unlockType: .likes, pointLevel: .premium, unlockAmount: 5)
        let stone3 = AssetModel(id: "3", type: .gems, thumbName: "thumb_crystal_27", thumbUrl: "",sceneName: "bead_plane_large", objNames: ["bead_plane_large"], textures: ["bead_plane_large": "bead3_red.png"], opacity: nil, roughness: ["bead_plane_large": 0.2], metalness: ["bead_plane_large": 0.2], normal: ["bead_plane_large": "bead3_nmp.jpg"], doubleSided: nil, scale: 1, unlockType: .coins, pointLevel: .exclusive, unlockAmount: 12)
        let stone4 = AssetModel(id: "4", type: .gems, thumbName: "thumb_crystal_28", thumbUrl: "", sceneName: "bead_plane_large", objNames: ["bead_plane_large"], textures: ["bead_plane_large": "bead3_green.png"], opacity: nil, roughness: ["bead_plane_large": 0.2], metalness: ["bead_plane_large": 0.2], normal: ["bead_plane_large": "bead3_nmp.jpg"], doubleSided: nil, scale: 1, unlockType: .ad, pointLevel: .basic, unlockAmount: 2)
        let pearl = AssetModel(id: "5", type: .gems, thumbName: "thumb_crystal_82", thumbUrl: "", sceneName: "ball", objNames: ["ball"], textures: ["ball": "hair_ball_white.jpg"], opacity: nil, roughness: ["ball": 0.2], metalness: ["ball": 0.4], normal: [:], doubleSided: nil, scale: 0.7, unlockType: .diamonds, pointLevel: .premium, unlockAmount: 8)
        return [stone1, stone2, stone3, stone4, pearl]
    }

    static var mockEarringsData: [AssetModel] {
        let earring0 = AssetModel(id: "9", type: .earrings, thumbName: "thumb_hair_access_163", thumbUrl: "", sceneName: "earring_hollow_loop", objNames: ["earring_hollow_loop"], textures: ["earring_hollow_loop": "piercing_1_gold_color.jpg"], opacity: nil, roughness: ["earring_hollow_loop": 0.2], metalness: ["earring_hollow_loop": 0.8], normal: [:], doubleSided: nil, scale: 1, unlockType: .likes, pointLevel: .exclusive, unlockAmount: 15)
        let earring = AssetModel(id: "10", type: .earrings, thumbName: "thumb_hair_access_163", thumbUrl: "", sceneName: "earring_circle", objNames: ["earring_circle"], textures: ["earring_circle": "piercing_1_gold_color.jpg"], opacity: nil, roughness: ["earring_circle": 0.2], metalness: ["earring_circle": 0.8], normal: [:], doubleSided: nil, scale: 1, unlockType: .likes, pointLevel: .exclusive, unlockAmount: 15)
        let earring1 = AssetModel(id: "12", type: .earrings, thumbName: "thumb_hair_access_164", thumbUrl: "", sceneName: "earring_ornament", objNames: ["earring_ornament"], textures: ["earring_ornament": "piercing_1_gold_color.jpg"], opacity: nil, roughness: ["earring_ornament": 0.2], metalness: ["earring_ornament": 0.8], normal: [:], doubleSided: nil, scale: 1, unlockType: .likes, pointLevel: .exclusive, unlockAmount: 15)
        let earring2 = AssetModel(id: "22", type: .earrings, thumbName: "thumb_hair_access_277", thumbUrl: "", sceneName: "Earring_2", objNames: ["Earring_2"], textures: ["Earring_2": "piercing_1_gold_color.jpg"], opacity: nil, roughness: ["Earring_2": 0.2], metalness: ["Earring_2": 0.8], normal: [:], doubleSided: nil, scale: 1, unlockType: .coins, pointLevel: .basic, unlockAmount: 3)
        let earring3 = AssetModel(id: "32", type: .earrings, thumbName: "thumb_hair_access_32", thumbUrl: "", sceneName: "Earring_3", objNames: ["Earring_3"], textures: ["Earring_3": "piercing_1_gold_color.jpg"], opacity: nil, roughness: ["Earring_3": 0.2], metalness: ["Earring_3": 0.8], normal: [:], doubleSided: nil, scale: 1, unlockType: .ad, pointLevel: .premium, unlockAmount: 6)
        
        return [earring0, earring, earring1, earring2, earring3]
    }

    static var mockNecklaceData: [AssetModel] {
        let necklace1 = AssetModel(id: "13", type: .necklace, thumbName: "thumb_crystal_36", thumbUrl: "", sceneName: "chain_6", objNames: ["chain_6"], textures: ["chain_6": "chain_1_gold.png"], opacity: nil, roughness: ["chain_6": 0.2], metalness: ["chain_6": 0.8], normal: ["chain_6": "chain_1_normal.jpg"], doubleSided: nil, scale: 1, unlockType: .coins, pointLevel: .exclusive, unlockAmount: 20)
        let necklace2 = AssetModel(id: "23", type: .necklace, thumbName: "thumb_crystal_36", thumbUrl: "", sceneName: "chain_1", objNames: ["chain_1"], textures: ["chain_1": "chain_1_gold.png"], opacity: nil, roughness: ["chain_1": 0.2], metalness: ["chain_1": 0.8], normal: ["chain_1": "chain_1_normal.jpg"], doubleSided: nil, scale: 1, unlockType: .coins, pointLevel: .exclusive, unlockAmount: 20)
        return [necklace1, necklace2]
    }

//    static var mockFaceGemsData: [AccessoryCollection] {
//        // Mock data for AssetModel
//        let assetModelRightPlacement = AssetModel(
//            id: "13",
//            type: .gems,
//            thumbName: "thumb_crystal_36", thumbUrl: "",
//            sceneName: "bead_plane_large",
//            objNames: ["bead_plane_large"],
//            textures: ["bead_plane_large": "bead_4_blue.png"],
//            opacity: nil,
//            roughness: ["bead_plane_large": 0.2],
//            metalness: ["bead_plane_large": 0.2],
//            normal: ["bead_plane_large": "bead_4_nmp.jpg"],
//            doubleSided: nil,
//            scale: 1.0
//        )
//
//        // Mock data for rightPlacement
//        let rightPlacement = AccessoryPlacement(
//            extraRot: 135.0,
//            position: SCNVector3(-2.122561, 10.784234, -27.898506),
//            rotation: SCNVector4(0.0, 0.0, 0.0, 0.0),
//            scale: SCNVector3(0.0, 0.0, 0.0),
//            normal: SCNVector3(-0.3369568, 0.90928704, -0.24424472),
//            randomRotate: nil,
//            bone: .base,
//            actualPosition: SCNVector3(-0.01717265, 0.27919203, 0.1080281),
//            actualRotation: SCNVector4(0.5342968, -0.30089527, 0.6013672, 0.51219773),
//            model: assetModelRightPlacement,
//            accessoryPosition: .center
//        )
//        
//        // Mock data for AssetModel instances for centerPlacement
//      
//        let assetModelCenterPlacement2 = AssetModel(
//            id: "33",  // ID for the second center placement model
//            type: .gems,
//            thumbName: "thumb_crystal_27", thumbUrl: "",
//            sceneName: "bead_plane_large",
//            objNames: ["bead_plane_large"],
//            textures: ["bead_plane_large": "bead3_red.png"],  // Different texture for this model
//            opacity: nil,
//            roughness: ["bead_plane_large": 0.2],
//            metalness: ["bead_plane_large": 0.2],
//            normal: ["bead_plane_large": "bead3_nmp.jpg"],
//            doubleSided: nil,
//            scale: 1.0
//        )
//
//        // Mock data for AssetModel instances for centerPlacement
//        let assetModelCenterPlacement1 = AssetModel(
//            id: "1",  // ID for the first center placement model
//            type: .gems,
//            thumbName: "thumb_crystal_36", thumbUrl: "",
//            sceneName: "bead_plane_large",
//            objNames: ["bead_plane_large"],
//            textures: ["bead_plane_large": "bead_4_blue.png"],
//            opacity: nil,
//            roughness: ["bead_plane_large": 0.2],
//            metalness: ["bead_plane_large": 0.2],
//            normal: ["bead_plane_large": "bead_4_nmp.jpg"],
//            doubleSided: nil,
//            scale: 1.0
//        )
//
//        // Mock data for centerPlacement with corresponding AssetModels
//        let centerPlacement1 = AccessoryPlacement(
//            extraRot: 0.0,
//            position: SCNVector3(-0.30131435, 10.742379, -29.151169),
//            rotation: SCNVector4(0.0, 0.0, 0.0, 0.0),
//            scale: SCNVector3(0.0, 0.0, 0.0),
//            normal: SCNVector3(0.0814873, 0.88463676, -0.45909372),
//            randomRotate: nil,
//            bone: .base,
//            actualPosition: SCNVector3(0.0011645983, 0.2915272, 0.107417494),
//            actualRotation: SCNVector4(0.51425093, -0.079568185, 0.048018966, 0.8525896),
//            model: assetModelCenterPlacement1,  // First model
//            accessoryPosition: .center
//        )
//
//        let centerPlacement2 = AccessoryPlacement(
//            extraRot: 90.0,
//            position: SCNVector3(-0.32891625, 11.262456, -26.251455),
//            rotation: SCNVector4(0.0, 0.0, 0.0, 0.0),
//            scale: SCNVector3(0.0, 0.0, 0.0),
//            normal: SCNVector3(-0.095498614, 0.99340636, 0.06336665),
//            randomRotate: nil,
//            bone: .base,
//            actualPosition: SCNVector3(0.0006394354, 0.2625346, 0.11262404),
//            actualRotation: SCNVector4(0.6883663, 0.23919581, -0.16140412, 0.66549677),
//            model: assetModelCenterPlacement2,  // Second model with different texture
//            accessoryPosition: .center
//        )
//
//        let centerPlacement3 = AccessoryPlacement(
//            extraRot: 135.0,
//            position: SCNVector3(-0.3181505, 11.118932, -27.843702),
//            rotation: SCNVector4(0.0, 0.0, 0.0, 0.0),
//            scale: SCNVector3(0.0, 0.0, 0.0),
//            normal: SCNVector3(-0.0901971, 0.9633312, -0.25269887),
//            randomRotate: nil,
//            bone: .base,
//            actualPosition: SCNVector3(0.00089877925, 0.27845505, 0.111186),
//            actualRotation: SCNVector4(0.3499333, -0.50061613, 0.687357, 0.39302745),
//            model: assetModelCenterPlacement1,  // Reusing the first model
//            accessoryPosition: .center
//        )
//
//        // Create AccessoryCollection with rightPlacement
//        let accessoryCollection = AccessoryCollection(
//            id: "9C6080FF-4BC7-4E58-8E25-C0A254444ADF",
//            type: .faceGems,
//            thumbName: "", thumbUrl: "",
//            rightPlacement: [rightPlacement],
//            centerPlacement: [centerPlacement1, centerPlacement2, centerPlacement3], gemIds: ["1", "2"] // Add center placements as needed
//        )
//        
//        return [accessoryCollection]
//    }
}
