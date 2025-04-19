//
//  CameraPosition.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-31.
//

import RealityKit

public enum CameraPosition: String, CaseIterable, Hashable {
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

extension CameraPosition {
    /// Returns the minimum and maximum Z thresholds for zooming in this position.
    var zoomThresholds: (min: Float, max: Float) {
        switch self {
        case .start:      return (min: 0.16, max: 0.6)
        case .zoomFace:   return (min: 0.12, max: 0.4)
        case .center:     return (min: 0.18, max: 0.7)
        case .zoomEar:    return (min: 0.14, max: 0.5)
        case .zoomChest:  return (min: 0.16, max: 0.6)
        case .zoomForehead: return (min: 0.15, max: 0.45)
        case .body:       return (min: 0.20, max: 0.8)
        case .customization: return (min: 0.10, max: 0.5)
        }
    }
    
    /// Returns the corresponding Y range for a given position.
    var yOffsetRange: (min: Float, max: Float) {
        switch self {
        case .start:          return (min: -0.1, max: -0.1)
        case .zoomFace:       return (min: 0.05, max: 0.0)
        case .center:         return (min: 0.05, max: 0.12)
        case .zoomEar:        return (min: 0.0, max: 0.2)
        case .zoomChest:      return (min: 0.15, max: 0.3)
        case .zoomForehead:   return (min: 0.1, max: 0.15)
        case .body:           return (min: 0.05, max: 0.2)
        case .customization:  return (min: 0.0, max: 0.15)
        }
    }
}
