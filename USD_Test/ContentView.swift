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
}

struct ARContainerView: UIViewRepresentable {
    
    @Binding var zoom: Float
    let headModel: HeadModel
    let faceModel: FaceModel
    let browModel: BrowModel
    let lashesModel: LashesModel
    let eyesModel: EyesModel
    let earringsModel: EarringsModel

    class Coordinator: NSObject {
        var anchor: AnchorEntity?
        
        // This function will be called when the ARView is tapped.
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = gesture.view as? ARView else { return }
            let tapLocation = gesture.location(in: arView)
            
            // Perform a hit test to find the tapped entity.
            if let tappedEntity = arView.entity(at: tapLocation) {
                // Check if the tapped entity is one of our spheres.
                print("Sphere tapped!")
                // For example, change its color to green.
                if var modelEntity = tappedEntity as? ModelEntity {
                   
                    NotificationCenter.default.post(name: .accessoryTapped, object: modelEntity)
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Set up your AR scene.
        AttachmentSystem.registerSystem()
        AttachmentComponent.registerComponent()
        
        let baseDistance: Float = 0.25
        let minDistance: Float = 0.02
        let distance = minDistance + (baseDistance - minDistance) * (9 - zoom) / 9
        
        let anchor = AnchorEntity(world: [0, -0.2, -distance])
        for clone in faceModel.clones {
            anchor.addChild(clone)
        }
        anchor.addChild(headModel.headArmature)
        anchor.addChild(lashesModel.lashesArmature)
        anchor.addChild(browModel.browArmature)
        anchor.addChild(eyesModel.eyesInnerArmature)
        anchor.addChild(eyesModel.eyesOuterArmature)
        
        // Add the head (and other models) to the scene.
        arView.scene.addAnchor(anchor)
        context.coordinator.anchor = anchor
        setupEnvironment(for: arView)
        arView.session.pause()
        
        // Set up earrings by first attaching them to the head.
        // Then add the earring parent entity to the scene.
        let earringAnchor = AnchorEntity()
        earringAnchor.addChild(earringsModel.parent)
        earringsModel.headModel = headModel.headArmature
        arView.scene.addAnchor(earringAnchor)
        
        // Rotate the anchor.
        anchor.orientation = simd_quatf(angle: .pi/6, axis: SIMD3<Float>(0, 1, 0))
        
        // Add the tap gesture recognizer.
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
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
        if let anchor = context.coordinator.anchor {
            let baseDistance: Float = 0.2
            let minDistance: Float = 0.001
            let distance = minDistance + (baseDistance - minDistance) * (9 - zoom) / 1
            anchor.transform = Transform(translation: SIMD3<Float>(0, 0, -distance))
           // anchor.orientation = simd_quatf(angle: .pi/6, axis: SIMD3<Float>(0, 1, 0))
        }
    }
}

struct ContentView: View {
    @State private var zoom: Float = 10
    @StateObject private var headModel = HeadModel()
    @StateObject private var faceModel = FaceModel()
    @StateObject private var browModel = BrowModel()
    @StateObject private var lashesModel = LashesModel()
    @StateObject private var eyesModel = EyesModel()
    @StateObject private var earringsModel = EarringsModel()

    var body: some View {
        VStack {
            ARContainerView(zoom: $zoom, headModel: headModel, faceModel: faceModel, browModel: browModel, lashesModel: lashesModel, eyesModel: eyesModel, earringsModel: earringsModel)
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                Slider(value: $zoom, in: 5.0...18, step: 1)
                    .padding()
                    .accentColor(.blue)
                
                Button("Start Animation") {
                    headModel.playAnimation()
                    faceModel.playAnimation()
                    browModel.playAnimation()
                    lashesModel.playAnimation()
                    eyesModel.playAnimation()
                }
                Button("load ear") {
                    earringsModel.loadModelOnAvatar(AssetModel.mockEarringsData[0])
                }
                Button("load access") {
                    earringsModel.selectAsset(accessoryModel)
                }
            }
            
            Text("Zoom: \(zoom, specifier: "%.1f")")
                .padding()
        }
    }
    
    var accessoryModel: AssetModel {
        return AssetModel(id: "1", type: .gems,
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
                                   unlockAmount: 1)
    }
}

#Preview {
    ContentView()
}
