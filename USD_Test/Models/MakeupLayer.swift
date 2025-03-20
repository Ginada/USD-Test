//
//  MakeupLayer.swift
//  MakeoverGame-iOS
//
//  Created by Gina Adamova on 2023-12-26.
//

import Foundation

struct MakeupAsset: Codable, Equatable, Identifiable {
    var id: String
    var type: MakeupType
    var mask: Int
    var morphValue: Float?
    
    var thumbName: String {
        return "\(type.thumbName)_\(mask)"
    }
}

protocol FashionAssetType {
    var id: String { get }
    var thumbName: String { get }
    var type: AssetCategory { get }
    var sceneName: String { get }
    var objNames: [String] { get }
    var textures: [String : String] { get }
    var roughness: [String : CGFloat]? { get }
    var metalness: [String : CGFloat]? { get }
    var normal: [String : String]? { get }
    var doubleSided: [String]? { get }
    var opacity: [String : CGFloat]? { get }
    var scale: Float? { get }
}

struct MakeupLayer: Layer, Codable, Equatable, Identifiable, Hashable {
    
    var id: String {
        return asset.type.maskBaseName + "\(asset.mask)"
    }
    
    var asset: MakeupAsset
    var order: Int
    var blur: Int
    var transparency: Float?
    var material: MakeupMat?
    var paletteType: PaletteType
    var paletteIndex: Int?
    
    var maskImage: String {
        if blur == 1 {
            return "\(asset.type.maskBaseName)_\(asset.mask)_blur"
        }
        if blur == 2 {
            return "\(asset.type.maskBaseName)_\(asset.mask)_blur2"
        }
        return "\(asset.type.maskBaseName)_\(asset.mask)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(order)
        hasher.combine(blur)
        hasher.combine(transparency)
        hasher.combine(material)
        hasher.combine(paletteType)
        hasher.combine(paletteIndex)
    }
    
    static func == (lhs: MakeupLayer, rhs: MakeupLayer) -> Bool {
        return lhs.id == rhs.id &&
            lhs.asset == rhs.asset &&
            lhs.order == rhs.order &&
            lhs.blur == rhs.blur &&
            lhs.transparency == rhs.transparency &&
            lhs.material == rhs.material &&
            lhs.paletteType == rhs.paletteType &&
            lhs.paletteIndex == rhs.paletteIndex
    }
}

protocol Layer: Codable, Equatable, Identifiable {

    //var type: MakeupType {get set}
    var order: Int {get set}
   // var mask: Int {get set}
    var blur: Int {get set}
    var transparency: Float? {get set}
    var material: MakeupMat? {get set}
    var asset: MakeupAsset {get set}
}

extension MakeupLayer {
    
    static var mockedData: [MakeupLayer] {
        let material = MakeupMat(id: "1", color: "#2E996D", finish: .dewy)
        let asset1 = MakeupAsset(id: "asset1", type: .eyeshadow, mask: 1, morphValue: nil)
        let layer = MakeupLayer(asset: asset1, order: 1, blur: 0, transparency: 0.5, material: material, paletteType: .shadow)
        
        let material2 = MakeupMat(id: "2", color: "#3474C0", finish: .metallic)
        let asset2 = MakeupAsset(id: "asset2", type: .eyeshadow, mask: 3, morphValue: nil)
        let layer2 = MakeupLayer(asset: asset2, order: 1, blur: 0, transparency: 0.7, material: material2, paletteType: .mid)
        
        let material3 = MakeupMat(id: "13", color: "#C5AC72", finish: .cream)
        let asset3 = MakeupAsset(id: "asset3", type: .foundation, mask: 2, morphValue: nil)
        let layer3 = MakeupLayer(asset: asset3, order: 1, blur: 0, transparency: 0.8, material: material3, paletteType: .highlight)
        
        let material4 = MakeupMat(id: "14", color: "#DCABFC", finish: .metallic)
        let asset4 = MakeupAsset(id: "asset4", type: .eyeliner, mask: 9, morphValue: nil)
        let layer4 = MakeupLayer(asset: asset4, order: 1, blur: 0, transparency: 0.8, material: material4, paletteType: .highlight)
        
        return [layer, layer2, layer3, layer4]
    }
}

