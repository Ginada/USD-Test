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

struct ARContainerView: UIViewRepresentable {
    
    let headModel: HeadModel
    let faceModel: FaceModel
    let browModel: AvatarComponent
    let lashesModel: LashesModel
    let eyesModel: EyesModel
    let earringsModel: EarringsModel
    let necklaceModel: NecklaceModel
    let hairModel: HairModel
    let hairAccessoryModel: HairAccessoryModel
    let clothingModel: ClothingModel
    let environmentModel: EnvironmentModel
    @ObservedObject var cameraController: CameraController


    class Coordinator: NSObject {
        var modelsAnchor: AnchorEntity?  // Anchor for models that rotate.
        var staticAnchor: AnchorEntity?    // Anchor for environment and lights.
        var cameraAnchor: AnchorEntity?
        var initialCameraZ: Float = 0.0
        
        // For pan gesture rotation.
        var cumulativeYRotation: Float = 0.0
        var initialPanYRotation: Float = 0.0
        
        var cancellable: AnyCancellable?
        
        // Tap gesture handler.
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = gesture.view as? ARView else { return }
            let tapLocation = gesture.location(in: arView)
            if let tappedEntity = arView.entity(at: tapLocation) {
                print("Entity tapped!")
                if let modelEntity = tappedEntity as? ModelEntity {
                    if modelEntity.name.contains("earx") || modelEntity.name.contains("hairx") {
                        NotificationCenter.default.post(name: .accessoryTapped, object: modelEntity)
                    } else if modelEntity.name.contains("neckx") {
                        NotificationCenter.default.post(name: .necklaceAccessoryTapped, object: modelEntity)
                    }
                }
            }
        }
        
        // Pan gesture handler for rotating models (only around the Y axis) with clamped rotation.
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let modelsAnchor = modelsAnchor else { return }
            let translation = gesture.translation(in: gesture.view)
            // Sensitivity: adjust as needed.
            let sensitivity: Float = 0.1
            
            if gesture.state == .began {
                initialPanYRotation = cumulativeYRotation
            } else if gesture.state == .changed {
                let deltaAngle = Float(translation.x) * sensitivity
                var newAngle = initialPanYRotation + deltaAngle
                newAngle = max(-45, min(newAngle, 45))
                cumulativeYRotation = newAngle
                modelsAnchor.orientation = simd_quatf(angle: newAngle * (.pi / 180), axis: SIMD3<Float>(0, 1, 0))
            }
        }
        
        // Pinch gesture handler for zooming.
        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard let cameraAnchor = cameraAnchor else { return }
            
            if gesture.state == .began {
                initialCameraZ = cameraAnchor.position.z
            } else if gesture.state == .changed {
                let rawNewZ = initialCameraZ / Float(gesture.scale)
                let newZ = max(0.16, min(rawNewZ, 0.6))
                let normalized = (newZ - 0.16) / (0.6 - 0.16)
                // Inverted mapping: at z=0.16 -> y = 0.3, at z=0.6 -> y = -0.1.
                let newY = normalized * (-0.4) + 0.3
                cameraAnchor.position = SIMD3<Float>(0, newY, newZ)
            }
        }
        
        /// Animates the camera to a new position defined by a CameraPosition.
        func updateCameraPosition(to position: CameraPosition, duration: TimeInterval = 0.5) {
            guard let cameraAnchor = cameraAnchor else { return }
            let targetTransform = position.transform
            cameraAnchor.move(to: targetTransform, relativeTo: nil, duration: duration)
        }
    }
    
    func makeCoordinator() -> Coordinator {
           let coordinator = Coordinator()
           // Subscribe to cameraController's published cameraPosition.
           coordinator.cancellable = cameraController.$cameraPosition.sink { [weak coordinator] newPosition in
               coordinator?.updateCameraPosition(to: newPosition)
           }
           return coordinator
       }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Register systems/components.
        AttachmentSystem.registerSystem()
        AttachmentComponent.registerComponent()
        
        // Create a models anchor for all rotatable content.
        let modelsAnchor = AnchorEntity(world: [0, -0.2, -0.2])
        modelsAnchor.addChild(faceModel.parent)
        modelsAnchor.addChild(headModel.armature.first!)
        modelsAnchor.addChild(lashesModel.armature.first!)
        modelsAnchor.addChild(browModel.armature.first!)
        eyesModel.createModel(skeleton: headModel.armature.first!)
        modelsAnchor.addChild(eyesModel.parent)
        modelsAnchor.addChild(necklaceModel.parent)
        modelsAnchor.addChild(hairModel.parent)
        modelsAnchor.addChild(clothingModel.parent)
        context.coordinator.modelsAnchor = modelsAnchor
        arView.scene.addAnchor(modelsAnchor)
        
        // Create a static anchor for environment and lights.
        let staticAnchor = AnchorEntity(world: [0, -0.2, -0.2])
        staticAnchor.addChild(environmentModel.environment!)
        do {
            let lights = try Entity.load(named: "Lights")
            staticAnchor.addChild(lights)
        } catch {
            fatalError("Failed to load lights.")
        }
        context.coordinator.staticAnchor = staticAnchor
        arView.scene.addAnchor(staticAnchor)
        
        // Set up the camera in its own anchor.
        let cameraEntity = PerspectiveCamera()
        cameraEntity.camera.fieldOfViewInDegrees = 50
        let cameraAnchor = AnchorEntity(world: .zero)
        cameraAnchor.addChild(cameraEntity)
        arView.scene.addAnchor(cameraAnchor)
        cameraAnchor.position = SIMD3<Float>(0, 0, 0.6)
        context.coordinator.cameraAnchor = cameraAnchor
        
        // Add gesture recognizers.
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        arView.addGestureRecognizer(pinchGesture)
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        arView.addGestureRecognizer(panGesture)
        
        // Additional anchors for earrings and hair accessories.
        let earringAnchor = AnchorEntity()
        earringAnchor.addChild(earringsModel.parent)
        earringsModel.headModel = headModel.armature.first!
        arView.scene.addAnchor(earringAnchor)
        
        let hairAccessoryAnchor = AnchorEntity()
        hairAccessoryAnchor.addChild(hairAccessoryModel.parent)
        hairAccessoryModel.headModel = headModel.armature.first!
        arView.scene.addAnchor(hairAccessoryAnchor)
        
        setupEnvironment(for: arView)
        arView.session.pause()
        
        return arView
    }
    
    func setupEnvironment(for arView: ARView) {
        do {
            let environmentResource = try EnvironmentResource.load(named: "env")
            arView.environment.lighting.resource = environmentResource
            arView.backgroundColor = UIColor.white
        } catch {
            print("Failed to load environment resource: \(error)")
        }
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Force reading the property to trigger an update.
    }
}

struct ContentView: View {
    @State private var eyeRotation = Angle(degrees: 0)
    @StateObject private var headModel = HeadModel()
    @StateObject private var faceModel = FaceModel()
    @StateObject private var browModel = BrowModel()
    @StateObject private var lashesModel = LashesModel()
    @StateObject private var eyesModel = EyesModel()
    @StateObject private var earringsModel = EarringsModel()
    @StateObject private var necklaceModel = NecklaceModel()
    @StateObject private var hairModel = HairModel()
    @StateObject private var hairAccessoryModel = HairAccessoryModel()
    @StateObject private var clothingModel = ClothingModel()
    @StateObject private var environmentModel = EnvironmentModel()
    
    @StateObject private var cameraController = CameraController()

    var body: some View {
        VStack {
            ARContainerView(
                headModel: headModel,
                faceModel: faceModel,
                browModel: browModel,
                lashesModel: lashesModel,
                eyesModel: eyesModel,
                earringsModel: earringsModel,
                necklaceModel: necklaceModel,
                hairModel: hairModel,
                hairAccessoryModel: hairAccessoryModel,
                clothingModel: clothingModel,
                environmentModel: environmentModel,
                cameraController: cameraController
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    
                    Button("Start Animation") {
                        headModel.playAnimation(name: "idle")
                        faceModel.playAnimation(name: "idle")
                        browModel.playAnimation(name: "idle")
                        lashesModel.playAnimation(name: "idle")
                        necklaceModel.playAnimation(name: "idle")
                        hairModel.playAnimation(name: "idle")
                        clothingModel.playAnimation(name: "idle")
                    }
                    
                    Button("load ear") {
                        earringsModel.loadModelOnAvatar(AssetModel.mockEarringsData[0])
                    }
                    
                    Button("load access") {
                        earringsModel.selectAsset(accessoryModel)
                        necklaceModel.selectAsset(accessoryModel)
                    }
                }
                HStack {
                    Button(action: {
                        necklaceModel.loadModelOnAvatar(AssetModel.mockNecklaceData.first!)
                    }) {
                        Text("Load necklace")
                    }
                    Button(action: {
                        hairModel.loadModel(HairStyle.mediumFrontWayvy.hairStyleModel)
                    }) {
                        Text("Load hair")
                    }
                    Button(action: {
                        hairAccessoryModel.loadModel("hair_medium_wayvy_placement_relative")
                    }) {
                        Text("Load hairAccessories")
                    }
                    Button(action: {
                        let model = AssetModel.mockClothingData[3]
                        clothingModel.loadModel(model)
                    }) {
                        Text("Load top")
                    }
                    Button(action: {
                        selectMakeup()
                    }) {
                        Text("Makeup")
                    }
                    Button(action: {
                        if let style = MakeupStyle.mockedLashesData()[1] as? MakeupStyle {
                            lashesModel.updateLashes(layer: style.layers.first!)
                        }
                    }) {
                        Text("Lashes")
                    }
                    Button(action: {
                        if let style = MakeupStyle.mockeEyebrowData()[1] as? MakeupStyle {
                            browModel.updateBrows(layer: style.layers.first!)
                        }
                    }) {
                        Text("Brows")
                    }
                    Button(action: {
                        if let color = EyeColorModel.mockEyeColorStyles.first {
                            eyesModel.updateColor(color: color)
                        }
                    }) {
                        Text("Eyes")
                    }
                    Button(action: {
                        updateFaceShapes()
                    }) {
                        Text("Shape")
                    }
                    Button(action: {
                        environmentModel.loadEnvironment(background: "office_background")
                    }) {
                        Text("Background")
                    }
                }
                HStack {
                    ForEach(Array(CameraPosition.allCases), id: \.self) { position in
                        Button(action: {
                            cameraController.cameraPosition = position
                        }) {
                            Text(position.rawValue)
                        }
                    }
                }
                    
                    // Slider for eye rotation.
                Slider(
                    value: Binding(
                        get: { self.eyeRotation.degrees },
                        set: { newVal in
                            self.eyeRotation = Angle(degrees: newVal)
                            // Update eyes rotation (xAngle: newVal, yAngle: 0 in this example)
                            eyesModel.updateEyeRotation(xAngle: Float(newVal), yAngle: 0)
                        }
                    ),
                    in: -45...45,
                    step: 1
                )
                .padding()
                .accentColor(.blue)
            }
        }
    }
    
    
    
    private func updateFaceShapes() {
        let shapes = [FaceShape.browsInLower : -1, FaceShape.eyesDroopy : -0.4, FaceShape.chinShort : 0.7, FaceShape.jawOpen: 0.3, FaceShape.eyeHorizontal: 0.7]
        for (shape, weight) in shapes {
            headModel.updateShape(with: shape, weight: weight)
            faceModel.updateShape(with: shape, weight: weight)
            browModel.updateShape(with: shape, weight: weight)
            lashesModel.updateShape(with: shape, weight: weight)
        }
    }
    
    private func selectMakeup() {
        for layer in MakeupLayer.mockedData {
            faceModel.selectedMakeupWith(layer: layer)
        }
    }
    
    var accessoryModel: AssetModel {
        return AssetModel(
            id: "1",
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
}

#Preview {
    ContentView()
}

class CameraController: ObservableObject {
    @Published var cameraPosition: CameraPosition = .start
}
