//
//  EnvironmentModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-30.
//

import RealityKit
import Foundation
import UIKit

class EnvironmentModel: ObservableObject {
    
    var environment: ModelEntity?
    
    init() {
        guard let url = Bundle.main.url(forResource: "background", withExtension: "usdc", subdirectory: "Art.scnassets/USD") else {
            fatalError("Unable to locate the head model in the bundle")
        }
        let scene = try! Entity.load(contentsOf: url)
        guard let background = scene.findEntity(named: "Plane")?.children.first as? ModelEntity else {
            fatalError("Head Armature not found")
        }
        let transform = Transform(
            scale: SIMD3<Float>(0.5, 0.5, 0.5),
            rotation: simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0)),
            translation: SIMD3<Float>(0, 0, -0.15)
        )
      
        background.transform = transform
        self.environment = background
    }
    
    func loadEnvironment(background: String) {
        do {
            let texture = try TextureResource.load(named: background)
            let material = UnlitMaterial(texture: texture)
            environment?.model?.materials = [material]
        } catch {
            fatalError("Failed to load background image.")
        }
    }
}
