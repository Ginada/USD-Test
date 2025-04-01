//
//  CameraPosition.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-31.
//

import RealityKit

enum CameraPosition: String, CaseIterable, Hashable {
    case start
    case zoomFace
    case center
    case zoomEar
    case zoomChest
    case zoomForehead
    case body
    case customization
}

struct CameraConfiguration {
    let translation: SIMD3<Float>
    let rotation: simd_quatf
}

extension CameraPosition {
    /// Returns a configuration (translation and rotation) for this camera position.
    var configuration: CameraConfiguration {
        switch self {
        case .start:
            // Example values: Adjust as needed.
            return CameraConfiguration(translation: SIMD3<Float>(0, 0.0, 0.4),
                                       rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)))
        case .zoomFace:
            return CameraConfiguration(translation: SIMD3<Float>(0, 0.05, 0.2),
                                       rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)))
        case .center:
            return CameraConfiguration(translation: SIMD3<Float>(0, 0.05, 0.5),
                                       rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)))
        case .zoomEar:
            return CameraConfiguration(translation: SIMD3<Float>(-0.2, 0.1, 0.1),
                                       rotation: simd_quatf(angle: -.pi/8, axis: SIMD3<Float>(0, 1, 0)))
        case .zoomChest:
            return CameraConfiguration(translation: SIMD3<Float>(0, -0.05, 0.3),
                                       rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)))
        case .zoomForehead:
            return CameraConfiguration(translation: SIMD3<Float>(0, 0.05, 0.2),
                                       rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)))
        case .body:
            return CameraConfiguration(translation: SIMD3<Float>(0, 0.0, 0.5),
                                       rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)))
        case .customization:
            return CameraConfiguration(translation: SIMD3<Float>(0, 0.0, 0.3),
                                       rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)))
        }
    }
    
    /// Returns a Transform for this camera position.
    var transform: Transform {
        let config = self.configuration
        return Transform(scale: SIMD3<Float>(1, 1, 1), rotation: config.rotation, translation: config.translation)
    }
}
