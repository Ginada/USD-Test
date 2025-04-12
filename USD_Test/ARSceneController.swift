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
    
    var applicationState: ApplicationState = .none
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    func playAnimation(_ name: String) {
        headModel.playAnimation(name: name)
        faceModel.playAnimation(name: name)
        browModel.playAnimation(name: name)
        lashesModel.playAnimation(name: name)
        necklaceModel.playAnimation(name: name)
        hairModel.playAnimation(name: name)
        clothingModel.playAnimation(name: name)
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
    
    func loadHair() {
        hairModel.loadModel(HairStyle.mediumFrontWayvy.hairStyleModel)
    }
    
    func loadEarrings(with asset: AssetModel) {
        earringsModel.loadModelOnAvatar(asset)
    }
    
    func updateCameraPosition(to position: CameraPosition) {
        cameraController.cameraPosition = CameraPosition.zoomEar
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
            earringsModel.selectAsset(style as! AssetModel)
            applicationState = .placement
        case .createEarring:
            break
        case .necklace:
            necklaceModel.selectAsset(style as! AssetModel)
            applicationState = .placement
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
        hairModel.loadModel(HairStyle.mediumFrontWayvy.hairStyleModel)
    }
    
    func removeStyle(selectedCategory: AssetCategory) {
        
    }
}
