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
                let material = MaterialManager.transparentMaterial()
                if var modelEntity = tappedEntity as? ModelEntity {
                    modelEntity.model?.materials = [material]
                    NotificationCenter.default.post(name: .accessoryTapped, object: tappedEntity)
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
        // anchor.addChild(earringsModel.earringLeft)
        arView.scene.addAnchor(anchor)
        
        context.coordinator.anchor = anchor
        setupEnvironment(for: arView)
        arView.session.pause()
        setupEarrings(arView: arView, headModel: headModel.headArmature, earringLeft: earringsModel.earringLeft, earringRight: earringsModel.earringRight)
        
        // Rotate the anchor 30° around the Y axis.
        anchor.orientation = simd_quatf(angle: .pi/7, axis: SIMD3<Float>(0, 1, 0))
        
        // Add tap gesture recognizer using the coordinator's handler.
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
            anchor.orientation = simd_quatf(angle: .pi/6, axis: SIMD3<Float>(0, 1, 0))
        }
    }
    
    func setupEarrings(arView: ARView, headModel: ModelEntity, earringLeft: ModelEntity, earringRight: ModelEntity) {
        guard let skeleton = headModel.findEntity(named: "Armature") as? ModelEntity else {
            fatalError("Head skeleton not found")
        }
        
        let earringOffset = Transform(
            scale: SIMD3<Float>(1, 1, 1),
            rotation: simd_quatf(angle: .pi/2, axis: SIMD3<Float>(1, 0, 0)),
            translation: SIMD3<Float>(0, 0, 0)
        ).matrix
        
        // Create or update the AttachmentComponent.
        var attachmentComponent: AttachmentComponent
        if let existing = skeleton.components[AttachmentComponent.self] as? AttachmentComponent {
            attachmentComponent = existing
        } else {
            attachmentComponent = AttachmentComponent()
        }
        
        // Setup right earring.
        if let jointChainRight = getJointHierarchy(skeleton, for: "Bone_earring_right") {
            let rightAttachment = Attachment(jointIndices: jointChainRight,
                                             offset: earringOffset,
                                             attachmentEntity: earringRight)
            attachmentComponent.attachments.append(rightAttachment)
        } else {
            fatalError("Right earring bone not found in head model.")
        }
        
        // Setup left earring.
        if let jointChainLeft = getJointHierarchy(skeleton, for: "Bone_earring_left") {
            let leftAttachment = Attachment(jointIndices: jointChainLeft,
                                            offset: earringOffset,
                                            attachmentEntity: earringLeft)
            attachmentComponent.attachments.append(leftAttachment)
        } else {
            fatalError("Left earring bone not found in head model.")
        }
        
        // Re-assign the updated component to the skeleton.
        skeleton.components.set(attachmentComponent)
        
        // Optionally add anchors.
        let leftAnchor = AnchorEntity()
        leftAnchor.addChild(earringLeft)
        arView.scene.addAnchor(leftAnchor)
        
        let rightAnchor = AnchorEntity()
        rightAnchor.addChild(earringRight)
        arView.scene.addAnchor(rightAnchor)
    }
    
    func getJointHierarchy(_ skeleton: ModelEntity, for jointSuffix: String) -> [Int]? {
        guard let targetIndex = skeleton.getJointIndex(suffix: jointSuffix) else {
            return nil
        }
        let targetJointName = skeleton.jointNames[targetIndex]
        var components = targetJointName.components(separatedBy: "/")
        
        var jointChain: [Int] = []
        while !components.isEmpty {
            let jointPath = components.joined(separator: "/")
            if let index = skeleton.jointNames.firstIndex(of: jointPath) {
                jointChain.append(index)
            } else {
                return nil
            }
            components.removeLast()
        }
        
        return jointChain
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
            }
            
            Text("Zoom: \(zoom, specifier: "%.1f")")
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
