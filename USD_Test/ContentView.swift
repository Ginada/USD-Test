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

    class Coordinator: NSObject {
        var anchor: AnchorEntity?
    }
    
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Correct the rotation of the face model: rotate -90° around X-axis.
        
        headModel.headArmature.orientation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
        browModel.browArmature.orientation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
        // Compute the initial distance based on zoom.
        let baseDistance: Float = 0.2
        let minDistance: Float = 0.02
        let distance = minDistance + (baseDistance - minDistance) * (10 - zoom) / 9
        
        let anchor = AnchorEntity(world: [0, -0.2, -distance])
        anchor.addChild(headModel.headArmature)
        for clone in faceModel.clones {
            anchor.addChild(clone)
        }
        anchor.addChild(browModel.browArmature)
        arView.scene.addAnchor(anchor)
        
        context.coordinator.anchor = anchor
        
        arView.session.pause()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let anchor = context.coordinator.anchor {
            let baseDistance: Float = 0.2
            let minDistance: Float = 0.001
            let distance = minDistance + (baseDistance - minDistance) * (10 - zoom) / 1
            anchor.transform = Transform(translation: SIMD3<Float>(0, 0, -distance))
        }
    }
}


struct ContentView: View {
    @State private var zoom: Float = 10
    @StateObject private var headModel = HeadModel()
    @StateObject private var faceModel = FaceModel()
    @StateObject private var browModel = BrowModel()

    var body: some View {
        VStack {
            ARContainerView(zoom: $zoom, headModel: headModel, faceModel: faceModel, browModel: browModel)
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                Slider(value: $zoom, in: 5.0...18, step: 1)
                    .padding()
                    .accentColor(.blue)
                
                Button("Start Animation") {
                    headModel.playAnimation()
                    faceModel.playAnimation()
                    browModel.playAnimation()
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
