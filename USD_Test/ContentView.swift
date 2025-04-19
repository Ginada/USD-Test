//
//  ContentView.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-09.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

extension Entity {
    func setMaterial(_ material: RealityKit.Material) {
        if var modelComponent = self.components[ModelComponent.self] {
            modelComponent.materials = [material]
            self.components.set(modelComponent)
        }
    }
    
    func setMaterials(_ materials: [RealityKit.Material]) {
        if var modelComponent = self.components[ModelComponent.self] {
            modelComponent.materials = materials
            self.components.set(modelComponent)
        }
    }
}

//struct ContentView: View {
//    @State private var eyeRotation = Angle(degrees: 0)
//    @StateObject private var headModel = HeadModel()
//    @StateObject private var faceModel = FaceModel()
//    @StateObject private var browModel = BrowModel()
//    @StateObject private var lashesModel = LashesModel()
//    @StateObject private var eyesModel = EyesModel()
//    @StateObject private var earringsModel = EarringsModel()
//    @StateObject private var necklaceModel = NecklaceModel()
//    @StateObject private var hairModel = HairModel()
//    @StateObject private var hairAccessoryModel = HairAccessoryModel()
//    @StateObject private var clothingModel = ClothingModel()
//    @StateObject private var environmentModel = EnvironmentModel()
//
//    @StateObject private var cameraController = CameraController()
//
//    var body: some View {
//        VStack {
//            ARContainerView(
//                headModel: headModel,
//                faceModel: faceModel,
//                browModel: browModel,
//                lashesModel: lashesModel,
//                eyesModel: eyesModel,
//                earringsModel: earringsModel,
//                necklaceModel: necklaceModel,
//                hairModel: hairModel,
//                hairAccessoryModel: hairAccessoryModel,
//                clothingModel: clothingModel,
//                environmentModel: environmentModel,
//                cameraController: cameraController
//            )
//            .edgesIgnoringSafeArea(.all)
//
//            // Additional UI for controls and animations.
//            controlPanel
//        }
//    }
//
//    var controlPanel: some View {
//        VStack {
//            HStack {
//                Button("Start Animation") {
//                    headModel.playAnimation(name: "idle")
//                    faceModel.playAnimation(name: "idle")
//                    browModel.playAnimation(name: "idle")
//                    lashesModel.playAnimation(name: "idle")
//                    necklaceModel.playAnimation(name: "idle")
//                    hairModel.playAnimation(name: "idle")
//                    clothingModel.playAnimation(name: "idle")
//                }
//                Button("load ear") {
//                    earringsModel.loadModelOnAvatar(AssetModel.mockEarringsData[0])
//                }
//                Button("load access") {
//                    earringsModel.selectAsset(accessoryModel)
//                    necklaceModel.selectAsset(accessoryModel)
//                }
//            }
//            HStack {
//                Button("Load necklace") {
//                    necklaceModel.loadModelOnAvatar(AssetModel.mockNecklaceData.first!)
//                }
//                Button("Load hair") {
//                    hairModel.loadModel(HairStyle.mediumFrontWayvy.hairStyleModel)
//                }
//                Button("Load hairAccessories") {
//                    hairAccessoryModel.loadModel("hair_medium_wayvy_placement_relative")
//                }
//                Button("Load top") {
//                    let model = AssetModel.mockClothingData[3]
//                    clothingModel.loadModel(model)
//                }
//                Button("Makeup") {
//                    selectMakeup()
//                }
//                Button("Lashes") {
//                    if let style = MakeupStyle.mockedLashesData()[1] as? MakeupStyle {
//                        lashesModel.updateLashes(layer: style.layers.first!)
//                    }
//                }
//                Button("Brows") {
//                    if let style = MakeupStyle.mockeEyebrowData()[1] as? MakeupStyle {
//                        browModel.updateBrows(layer: style.layers.first!)
//                    }
//                }
//                Button("Eyes") {
//                    if let color = EyeColorModel.mockEyeColorStyles.first {
//                        eyesModel.updateColor(color: color)
//                    }
//                }
//                Button("Shape") {
//                    updateFaceShapes()
//                }
//                Button("Background") {
//                    environmentModel.loadEnvironment(background: "office_background")
//                }
//            }
//            HStack {
//                ForEach(Array(CameraPosition.allCases), id: \.self) { position in
//                    Button(action: {
//                        cameraController.cameraPosition = position
//                    }) {
//                        Text(position.rawValue)
//                    }
//                }
//            }
//            Slider(
//                value: Binding(
//                    get: { self.eyeRotation.degrees },
//                    set: { newVal in
//                        self.eyeRotation = Angle(degrees: newVal)
//                        eyesModel.updateEyeRotation(xAngle: Float(newVal), yAngle: 0)
//                    }
//                ),
//                in: -45...45,
//                step: 1
//            )
//            .padding()
//            .accentColor(.blue)
//        }
//    }
//
//    private func updateFaceShapes() {
//        let shapes: [FaceShape: Double] = [
//            .browsInLower: -1,
//            .eyesDroopy: -0.4,
//            .chinShort: 0.7,
//            .jawOpen: 0.3,
//            .eyeHorizontal: 0.7
//        ]
//        for (shape, weight) in shapes {
//            headModel.updateShape(with: shape, weight: weight)
//            faceModel.updateShape(with: shape, weight: weight)
//            browModel.updateShape(with: shape, weight: weight)
//            lashesModel.updateShape(with: shape, weight: weight)
//        }
//    }
//
//    private func selectMakeup() {
//        for layer in MakeupLayer.mockedData {
//            faceModel.selectedMakeupWith(layer: layer)
//        }
//    }
//
//    var accessoryModel: AssetModel {
//        AssetModel(
//            id: "1",
//            type: .gems,
//            thumbName: "thumb_crystal_36",
//            thumbUrl: "",
//            sceneName: "shell_round",
//            objNames: ["shell_round"],
//            textures: ["shell_round": "shell_color.jpg"],
//            opacity: nil,
//            roughness: ["shell_round": 0.2],
//            metalness: ["shell_round": 0.2],
//            normal: ["shell_round": "shell_normal.jpg"],
//            doubleSided: nil,
//            scale: 0.8,
//            tags: [ThemeTag.clouds, ThemeTag.fairy],
//            unlockType: UnlockType.coins,
//            pointLevel: .basic,
//            unlockAmount: 1
//        )
//    }
//}

public struct ContentView: View {
    // Create your models as needed...
    @StateObject private var cameraController = CameraController()
    @State var controller = ARSceneController()
    
    // Create a sample accessory asset.
    private var accessoryModel: AssetModel {
        AssetModel(
            id: "1dfAS",
            type: .gems,
            thumbName: "thumb_crystal_36",
            thumbUrl: "",
            sceneName: "shell_round",
            objNames: ["shell_round"],
            textures: ["shell_round": "shell_color.jpg"],
            opacity: nil,
            roughness: ["shell_round": 0.2],
            metalness: ["shell_round": 0.2],
            normal: ["shell_round": "shell_normal.jpg"],
            doubleSided: nil,
            scale: 0.8,
            tags: [ThemeTag.clouds, ThemeTag.fairy],
            unlockType: UnlockType.coins,
            pointLevel: .basic,
            unlockAmount: 1
        )
    }
    
    public var body: some View {
        VStack {
            ARContainerView(
                // Pass your models as needed...
                controller: controller
            )
            .edgesIgnoringSafeArea(.all)
            ARControlPanelView(controller: controller)
        }
    }
}

public struct ARControlPanelView<Controller: ARSceneControlling>: View {
    public let controller: Controller
    
    public init(controller: Controller) {
        self.controller = controller
    }
    
    public var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    Button("Start Anim") {
                        controller.playAnimation("idle")
                    }
                    Button("Inbetween anim") {
                        controller.playAnimation("inbetween")
                    }
                    Button("Stop Anim") {
                        controller.stopAnimations()
                    }
                    Button("Load makeup") {
                        controller.selectStyle(style: MakeupStyle.mockedFoundationData()[0], selectedCategory: .foundation, palette: Palette.foundationPalette)
                    }
                    Button("reset") {
                        controller.resetModel()
                    }
                    Button("camera") {
                        controller.updateCameraPosition(to: CameraPosition.zoomFace)
                    }
                    
                    Button("accessory 1") {
                        controller.selectStyle(style: AssetModel.mockGemsData.first!, selectedCategory: .earrings, palette: Palette.eyeshadowPalette)
                    }
                    Button("accessory 2") {
                        controller.selectStyle(style: AssetModel.mockGemsData[1], selectedCategory: .earrings, palette: Palette.eyeshadowPalette)
                    }
                    Button("accessory Necklace") {
                        controller.selectStyle(style: AssetModel.mockGemsData[1], selectedCategory: .necklace, palette: Palette.eyeshadowPalette)
                    }
                    Button("shape") {
                        controller.updateFaceShape(setting: [.browsInLower: 1, .eyesDroopy: -0.4, .chinShort: 0.7, .smile: 0.9, .eyeHorizontal: -0.7])
                    }
                    Button("hair color") {
                        controller.updateHairColor(HairColor.blue_dark)
                    }
                    Button("body color") {
                        controller.updateBodyColor(.brightest)
                    }
                    Button("eye color") {
                        controller.updateEyeColor(.amber_halo)
                    }
                    Button("pose1") {
                        controller.setPose("pose_1_anim")
                    }
                    Button("pose2") {
                        controller.setPose("pose_2_anim")
                    }
                    Button("hide placements") {
                        controller.hidePlacements(category: .earrings)
                    }
                    Button("show placements") {
                        controller.showPlacements(category: .earrings)
                    }
                    Button("earring gem ids") {
                        print(controller.placedEarringGemIds())
                    }
                    Button("load hair placement") {
                        controller.loadHairAccessoryPlacementFile("hair_medium_wayvy_placement_relative")
                    }
                    Button("load hair placement") {
                        controller.showHairAccessory()
                    }
                    Button("necklace gem ids") {
                        print(controller.placedNecklaceGemIds())
                    }
                    Button("Load Necklace") {
                        controller.selectStyle(style: AssetModel.mockNecklaceData[0], selectedCategory: .necklace, palette: Palette.eyeshadowPalette)
                    }
                    Button("update face") {
                        controller.updateFaceShape(setting: [.browsInLower: 1, .eyesDroopy: -0.4, .chinShort: 0.7, .smile: 0.9, .eyeSize: 1, .noseSize: 1, .noseTipUp: 0.5, .eyeShapeRound: 0.5, .lipsWide: 0.5, .lipsLarge: 0.4])
                    }
                    Button("Load Earr") {
                        controller.selectStyle(style: AssetModel.mockEarringsData[0], selectedCategory: .earrings, palette: Palette.eyeshadowPalette)
                    }
                   
//                        controller.selectStyle(style: MakeupStyle.mockedEyeShadowData()[0], selectedCategory: .eyeshadow, palette: Palette.eyebrowPalette)
                }
            }
            HStack {
                Button("Load Hair") {
                    controller.loadHair()
                }
                Button("Camera: Front") {
                    controller.updateCameraPosition(to: .center)
                }
                //slider -0.9-0.9
                Slider(value: Binding(
                    get: {return 0.5}, set: { newValue in
                        controller.updateEyeSize(size: newValue)
                    }
                ), in: -1...1, step: 0.1)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

class CameraController: ObservableObject {
    @Published var cameraPosition: CameraPosition = .start
}
