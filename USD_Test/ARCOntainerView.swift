//
//  ARCOntainerView.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-04-02.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

public protocol ARSceneControlling: AnyObject {
    // Animation
    func playAnimation(_ name: String)
    func stopAnimations()
    func setPose(_ name: String)
    // Model
    func selectStyle(style: any AssetStyle, selectedCategory: AssetCategory, palette: Palette)
    func removeStyle(selectedCategory: AssetCategory)
    func loadHair()
    func updateHairColor(_ color: HairColor)
    func updateBodyColor(_ color: BodyColor)
    func updateEyeColor(_ color: EyeColor)
    func loadEarrings(with asset: AssetModel)
    func resetModel()
    func loadHairAccessoryPlacementFile(_ fileName: String)
    func showHairAccessory()
    func updateFaceShape(setting: [FaceShape: Double])
    func hidePlacements(category: AssetCategory)
    func showPlacements(category: AssetCategory)
    func placedEarringGemIds() -> [String]
    func placedNecklaceGemIds() -> [String]
    func updateEyeDistance(distance: Float)
    func updateEyeSize(size: Float)
    //func moveCamera(for assetCat: AssetCategory)
    func loadCustomAvatarModel(_ appearance: Appearance)
    // Camera
    
    func updateCameraPosition(to position: CameraPosition)
    
    
}

struct ARContainerView: UIViewRepresentable {
    
    // Models
    @ObservedObject var headModel: HeadModel
    @ObservedObject var faceModel: FaceModel
    @ObservedObject var browModel: AvatarComponent
    @ObservedObject var lashesModel: LashesModel
    @ObservedObject var eyesModel: EyesModel
    @ObservedObject var earringsModel: EarringsModel
    @ObservedObject var necklaceModel: NecklaceModel
    @ObservedObject var hairModel: HairModel
    @ObservedObject var hairAccessoryModel: HairAccessoryModel
    @ObservedObject var clothingModel: ClothingModel
    @ObservedObject var environmentModel: EnvironmentModel
    @ObservedObject var cameraController: CameraController
    
    
    init(controller: ARSceneController) {
        self.headModel = controller.headModel
        self.faceModel = controller.faceModel
        self.browModel = controller.browModel
        self.lashesModel = controller.lashesModel
        self.eyesModel = controller.eyesModel
        self.earringsModel = controller.earringsModel
        self.necklaceModel = controller.necklaceModel
        self.hairModel = controller.hairModel
        self.hairAccessoryModel = controller.hairAccessoryModel
        self.clothingModel = controller.clothingModel
        self.environmentModel = controller.environmentModel
        self.cameraController = controller.cameraController
    }

    // MARK: - Coordinator
    class Coordinator: NSObject {
        let parent: ARContainerView
        var modelsAnchor: AnchorEntity?    // Rotatable content anchor.
        var staticAnchor: AnchorEntity?      // Environment & lights anchor.
        var cameraAnchor: AnchorEntity?
        var initialCameraZ: Float = 0.0
        
        // For pan gesture rotation.
        var cumulativeYRotation: Float = 0.0
        var initialPanYRotation: Float = 0.0
        
        var cancellable: AnyCancellable?
        
        init(parent: ARContainerView) {
            self.parent = parent
            super.init()
        }
            
        
        // MARK: - Gesture Handlers
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = gesture.view as? ARView else { return }
            let tapLocation = gesture.location(in: arView)
            if let tappedEntity = arView.entity(at: tapLocation) {
                if let modelEntity = tappedEntity as? ModelEntity {
                    if modelEntity.name.contains("earx") || modelEntity.name.contains("hairx") {
                        NotificationCenter.default.post(name: .accessoryTapped, object: modelEntity)
                    } else if modelEntity.name.contains("neckx") {
                        NotificationCenter.default.post(name: .necklaceAccessoryTapped, object: modelEntity)
                    }
                }
            }
        }
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let modelsAnchor = modelsAnchor else { return }
            let translation = gesture.translation(in: gesture.view)
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
        
        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard let cameraAnchor = cameraAnchor else { return }
            // Retrieve the current camera position.
            let currentPosition = parent.cameraController.cameraPosition
            let thresholds = currentPosition.zoomThresholds
            let yRange = currentPosition.yOffsetRange
            

            if gesture.state == .began {
                initialCameraZ = cameraAnchor.position.z
            } else if gesture.state == .changed {
                let rawNewZ = initialCameraZ / Float(gesture.scale)
                let newZ = max(thresholds.min, min(rawNewZ, thresholds.max))
                let normalized = (newZ - thresholds.min) / (thresholds.max - thresholds.min)
                // Calculate newY based on the relative yOffset range.
                let newY = normalized * (yRange.max - yRange.min) + yRange.min
                cameraAnchor.position = SIMD3<Float>(0, newY, newZ)
            }
        }
        
        /// Animates the camera to a new position defined by a CameraPosition.
        func updateCameraPosition(to position: CameraPosition, duration: TimeInterval = 0.5) {
            guard let cameraAnchor = cameraAnchor else { return }
            cameraAnchor.move(to: position.transform, relativeTo: nil, duration: duration)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(parent: self)
        coordinator.cancellable = cameraController.$cameraPosition.sink { [weak coordinator] newPosition in
            coordinator?.updateCameraPosition(to: newPosition)
        }
        return coordinator
    }
    
    // MARK: - UIViewRepresentable Methods
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        registerSystems()
        
        // Setup anchors.
        let modelsAnchor = createModelsAnchor()
        let staticAnchor = createStaticAnchor()
        let cameraAnchor = createCameraAnchor()
        
        // Store anchors in the coordinator.
        context.coordinator.modelsAnchor = modelsAnchor
        context.coordinator.staticAnchor = staticAnchor
        context.coordinator.cameraAnchor = cameraAnchor
        
        // Add anchors to scene.
        arView.scene.addAnchor(modelsAnchor)
        arView.scene.addAnchor(staticAnchor)
        arView.scene.addAnchor(cameraAnchor)
        
        // Add additional accessory anchors.
        addAccessoryAnchors(to: arView)
        
        // Configure environment and gestures.
        setupEnvironment(for: arView)
        addGestureRecognizers(to: arView, coordinator: context.coordinator)
        
        // Pause session initially.
        arView.session.pause()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Trigger view updates if needed.
    }
    
    // MARK: - Helper Methods
    private func registerSystems() {
        AttachmentSystem.registerSystem()
        AttachmentComponent.registerComponent()
    }
    
    private func createModelsAnchor() -> AnchorEntity {
        let anchor = AnchorEntity(world: [0, -0.2, -0.2])
        anchor.addChild(faceModel.parent)
        anchor.addChild(faceModel.animationModel!)
        anchor.addChild(headModel.armature.first!)
        lashesModel.armature.forEach { model in
            anchor.addChild(model)
        }
        anchor.addChild(browModel.armature.first!)
        eyesModel.createModel(skeleton: headModel.armature.first!)
        anchor.addChild(eyesModel.parent)
        anchor.addChild(necklaceModel.parent)
        anchor.addChild(hairModel.parent)
        anchor.addChild(clothingModel.parent)
        return anchor
    }
    
    private func createStaticAnchor() -> AnchorEntity {
        let anchor = AnchorEntity(world: [0, -0.2, -0.2])
        if let env = environmentModel.environment {
            anchor.addChild(env)
        }
        do {
            let lights = try Entity.load(named: "Lights")
            anchor.addChild(lights)
        } catch {
            fatalError("Failed to load lights.")
        }
        return anchor
    }
    
    private func createCameraAnchor() -> AnchorEntity {
        let cameraEntity = PerspectiveCamera()
        cameraEntity.camera.fieldOfViewInDegrees = 50
        let anchor = AnchorEntity(world: .zero)
        anchor.addChild(cameraEntity)
        anchor.position = SIMD3<Float>(0, 0, 0.6)
        return anchor
    }
    
    private func addAccessoryAnchors(to arView: ARView) {
        // Earrings anchor.
        let earringAnchor = AnchorEntity()
        earringAnchor.addChild(earringsModel.parent)
        earringsModel.headModel = headModel.armature.first!
        arView.scene.addAnchor(earringAnchor)
        
        // Hair accessory anchor.
        let hairAccessoryAnchor = AnchorEntity()
        hairAccessoryAnchor.addChild(hairAccessoryModel.parent)
        hairAccessoryModel.headModel = headModel.armature.first!
        arView.scene.addAnchor(hairAccessoryAnchor)
    }
    
    private func addGestureRecognizers(to arView: ARView, coordinator: Coordinator) {
        let tapGesture = UITapGestureRecognizer(target: coordinator, action: #selector(Coordinator.handleTap(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: coordinator, action: #selector(Coordinator.handlePinch(_:)))
        let panGesture = UIPanGestureRecognizer(target: coordinator, action: #selector(Coordinator.handlePan(_:)))
        arView.addGestureRecognizer(tapGesture)
        arView.addGestureRecognizer(pinchGesture)
        arView.addGestureRecognizer(panGesture)
    }
    
    private func setupEnvironment(for arView: ARView) {
        do {
            let environmentResource = try EnvironmentResource.load(named: "env")
            arView.environment.lighting.resource = environmentResource
            arView.backgroundColor = UIColor.white
        } catch {
            print("Failed to load environment resource: \(error)")
        }
    }
}
