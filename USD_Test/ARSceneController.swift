//
//  ARSceneController.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-04-08.
//
import SwiftUI

class ARSceneController: ARSceneControlling {
    
    let headModel: HeadModel = HeadModel()
    let faceModel: FaceModel = FaceModel()
    let browModel: BrowModel = BrowModel()
    let lashesModel: LashesModel = LashesModel()
    let eyesModel: EyesModel = EyesModel()
    let earringsModel: EarringsModel = EarringsModel()
    let necklaceModel: NecklaceModel = NecklaceModel()
    let hairModel: HairModel = HairModel()
    let hairAccessoryModel: HairAccessoryModel = HairAccessoryModel()
    let clothingModel: ClothingModel = ClothingModel()
    let environmentModel: EnvironmentModel = EnvironmentModel()
    let cameraController: CameraController = CameraController()
    
    var animationModels: [AnimatableAvatar] {
        return [faceModel, headModel, browModel, lashesModel]
    }
    var applicationState: ApplicationState = .none
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    init() {
        let materialManager = MaterialManager.shared
    }
   
    func playAnimation(_ name: String) {
        headModel.playAnimation(name: name)
        faceModel.playAnimation(name: name)
        browModel.playAnimation(name: name)
        lashesModel.playAnimation(name: name)
        necklaceModel.playAnimation(name: name)
        hairModel.playAnimation(name: name)
        clothingModel.playAnimation(name: name)
        if name == "idle" {
            animationModels.forEach { model in
                model.startPingPongShapeAnimation(with: [(shape: .blink, weight: 1.0)], animationDuration: 0.2, pauseAtTarget: 0.0, loopPause: 5.0)
            }
            
        }
        if name == "inbetween" {
            animationModels.forEach { model in
                model.updateShapeAnimated(with: [(shape: .smile, weight: 0.8)], duration: 0.8, reverse: true, reversePause: 0.1)
            }
        }
    }
    
    func setPose(_ name: String) {
        headModel.setPose(name: name)
        faceModel.setPose(name: name)
        browModel.setPose(name: name)
        lashesModel.setPose(name: name)
        necklaceModel.setPose(name: name)
        hairModel.setPose(name: name)
        clothingModel.setPose(name: name)
    }
    
    func stopAnimations() {
        headModel.stopAnimations()
        faceModel.stopAnimations()
        browModel.stopAnimations()
        lashesModel.stopAnimations()
        necklaceModel.stopAnimations()
        hairModel.stopAnimations()
        clothingModel.stopAnimations()
    }
    
    func updateEyeSize(size: Float) {
        eyesModel.updateEyeScale(size)
    }
    
    func loadHair() {
        hairModel.loadModel(HairStyle.mediumFrontWayvy.hairStyleModel)
    }
    
    func loadEarrings(with asset: AssetModel) {
        earringsModel.loadModelOnAvatar(asset)
    }
    
    func updateCameraPosition(to position: CameraPosition) {
        cameraController.cameraPosition = position
    }
    
    func loadHairAccessoryPlacementFile(_ fileName: String) {
        hairAccessoryModel.setPlacementFile(fileName)
    }
    
    func showPlacements(category: AssetCategory) {
        switch category {
        case .earrings:
            earringsModel.showPlacements()
        case .necklace:
            necklaceModel.showPlacements()
        case .hairAccessories:
            hairAccessoryModel.showPlacements()
        default:
            break
        }
    }
    
    func hidePlacements(category: AssetCategory) {
        switch category {
        case .earrings:
            earringsModel.hidePlacements()
        case .necklace:
            necklaceModel.hidePlacements()
        case .hairAccessories:
            hairAccessoryModel.hidePlacements()
        default:
            break
        }
    }
    
    func selectStyle(style: any AssetStyle, selectedCategory: AssetCategory, palette: Palette) {
        generator.impactOccurred()
        switch style.type {
        case .contouring, .eyeliner, .eyeshadow, .foundation, .lips, .paint, .blush:
            selectMakeup(style: style as! MakeupStyle, palette: palette)
        case .eyebrow:
            selectEyebrows(style: style as! MakeupStyle, palette: palette)
        case .lashes:
            selectLashes(style: style as! MakeupStyle, palette: palette)
        case .hair:
            hairModel.loadModel(style as! HairStyleModel)
        case .fashion:
            clothingModel.loadModel(style as! AssetModel)
        case .hairAccessories:
            hairAccessoryModel.selectAsset(style as! AssetModel)
            applicationState = .placement
        case .gems:
            if selectedCategory == .earrings {
                earringsModel.selectAsset(style as! AssetModel)
            } else if selectedCategory == .necklace {
                necklaceModel.selectAsset(style as! AssetModel)
                // model.hideModelHead()
            } else if selectedCategory == .faceGems {
               
            }
        case .eyeColor:
            eyesModel.updateColor(color: style as! EyeColorModel)
        case .faceGems:
            break
        case .earrings:
            earringsModel.loadModelOnAvatar(style as! AssetModel)
        case .createEarring:
            break
        case .necklace:
            necklaceModel.loadModelOnAvatar(style as! AssetModel)
            //selectMakeup(style: style)
        }
    }
    
    func selectMakeup(style: MakeupStyle, palette: Palette) {
        //removeMakeup(for: style.type)
        removeMakeup(for: style.type)
        for layer in style.layers {
            var newLayer = layer
            if let materials = palette.materials(for: layer.paletteType) {
                newLayer.material = materials[layer.paletteIndex ?? 0]
                if style.type == .paint {
                    newLayer.asset.type = .paint
                }
            }
            faceModel.selectedMakeupWith(layer: newLayer)
        }
    }
    
    func selectEyebrows(style: MakeupStyle, palette: Palette) {
        for layer in style.layers {
            var newLayer = layer
            if let materials = palette.materials(for: layer.paletteType) {
                newLayer.material = materials[layer.paletteIndex ?? 0]
            }
            browModel.updateBrows(layer: newLayer)
        }
    }
    
    func selectLashes(style: MakeupStyle, palette: Palette) {
        for layer in style.layers {
            let palette = palette
            var newLayer = layer
            if let materials = palette.materials(for: layer.paletteType) {
                newLayer.material = materials[layer.paletteIndex ?? 0]
            }
            lashesModel.updateLashes(layer: newLayer)
        }
    }
    
    func removeMakeup(for assetCategory: AssetCategory) {
        switch assetCategory {
        case .contouring, .eyeshadow, .eyeliner, .foundation, .lips:
            assetCategory.makeupTypes.forEach { type in
                faceModel.removeAllFor(type: type)
            }
        case .paint:
            faceModel.removeAllForPaint()
        default:
            break
        }
    }
    
    func updateHairColor(_ color: HairColor) {
        hairModel.updateHairColor(color: color)
    }
    
    func updateBodyColor(_ color: BodyColor) {
        headModel.updateBodyColor(color)
    }
    
    func updateEyeColor(_ color: EyeColor) {
        eyesModel.updateEyeColor(color: color)
    }
    
    func removeStyle(selectedCategory: AssetCategory) {
        
    }
    
    func updateFaceShape(setting: [FaceShape: Double]) {
        headModel.updateFaceShape(settings: setting)
        lashesModel.updateFaceShape(settings: setting)
        faceModel.updateFaceShape(settings: setting)
        browModel.updateFaceShape(settings: setting)
        setting.forEach { shape, value in
            if shape == .eyeHorizontal {
                eyesModel.updateEyeDistance(distance: Float(value))
            }
            
            if shape == .eyeSize {
                eyesModel.updateEyeScale(Float(value))
            }
        }
    }
    
    func updateEyeDistance(distance: Float) {
        eyesModel.updateEyeDistance(distance: distance)
    }
    
    func resetModel() {
        // remove all makeup
        faceModel.removeAll()
        earringsModel.removeAll()
        necklaceModel.removeAll()
        hairAccessoryModel.removeAll()
        lashesModel.removeAll()
        browModel.removeAll()
        hairModel.removeAll()
        headModel.removeAll()
    }
    
    func showHairAccessory() {
        hairAccessoryModel.showHairAccessory()
    }
    
    func placedEarringGemIds() -> [String] {
        return earringsModel.placedGemIds()
    }
    
    func placedNecklaceGemIds() -> [String] {
        return necklaceModel.placedGemIds()
    }
    
    func setHairAccessoryPlacementFile(_ fileName: String) {
        hairAccessoryModel.setPlacementFile(fileName)
    }
    
    func loadCustomAvatarModel(_ appearance: Appearance) {
        
    }
    
}
