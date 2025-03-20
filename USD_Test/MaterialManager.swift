//
//  Material.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-14.
//

import RealityKit
import Foundation
import UIKit


class MaterialManager {
    
    static func createPBRMaterial(texture: String, normal: String?, doubleSided: Bool = false) -> PhysicallyBasedMaterial {
        var material = PhysicallyBasedMaterial()
        
        // Load and assign the base color texture.
        if let baseResource = try? TextureResource.load(named: texture) {
            // Create a material parameter from the texture resource.
            let baseColorTexture = MaterialParameters.Texture(baseResource)
            // Assign the texture to the material’s baseColor.
            material.baseColor = PhysicallyBasedMaterial.BaseColor(texture: baseColorTexture)
            material.blending = .init(blending: .transparent(opacity: 0.9999))
            material.opacityThreshold = 0.0 // IMPORTANT
            if doubleSided {
                material.faceCulling = .none
            }
        } else {
            // Fallback to a solid white tint if the texture fails to load.
            material.baseColor = .init(tint: .white, texture: nil)
            print("Error: Unable to load base texture named \(texture).")
        }
        
        if let normal = normal {
            // Load and assign the normal map texture.
            if let normalResource = try? TextureResource.load(named: normal) {
                let normalTexture = MaterialParameters.Texture(normalResource)
                material.normal = PhysicallyBasedMaterial.Normal(texture: normalTexture)
            } else {
                // Fallback: if normal map fails, leave it unassigned (or provide a default if desired).
                material.normal = .init(texture: nil)
                print("Error: Unable to load normal texture named \(normal).")
            }
        }
        
        return material
    }
    
    static func transparentMaterial() -> PhysicallyBasedMaterial {
        var material = PhysicallyBasedMaterial()
        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: .clear, texture: nil)
        material.blending = .transparent(opacity: 0.01)
        material.opacityThreshold = 0.0 // IMPORTANT
        return material
    }
    
    static func metallicMaterial(color: UIColor) -> PhysicallyBasedMaterial {
        var material = PhysicallyBasedMaterial()
        material.metallic = PhysicallyBasedMaterial.Metallic(0.8)
        material.roughness = PhysicallyBasedMaterial.Roughness(0.1)
        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: color, texture: nil)
        material.faceCulling = .none
        return material
    }

    static func createCustomFaceMaterial(color: UIColor, normal: String, opacity: String) -> CustomMaterial? {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Error creating default Metal device.")
        }
        guard let library = device.makeDefaultLibrary() else {
            return nil
        }
        
        // Create a base physically based material and configure its properties.
        var baseMaterial = MaterialManager.createPBRMaterial(color: color, normal: normal, opacity: opacity)
        baseMaterial.writesDepth = false
        // Load your opacity texture.
        var opacityTexture: TextureResource? = nil
        if let resource = try? TextureResource.load(named: opacity) {
            opacityTexture = resource
        } else {
            print("Error: Unable to load opacity texture named \(opacity).")
        }
        
        // Create a custom binding for your opacity: this could be a uniform that you pass into your shader.
        let opacityScale: Float = 1.0
        
        // Create your surface shader. (Assume you have a Metal shader function named "mySurfaceShader" in your .metal file.)
        let surfaceShader = CustomMaterial.SurfaceShader(named: "customMakeupShader", in: library)
        
        // Create the custom material using the base material.
        do {
            let customMaterial = try CustomMaterial(from: baseMaterial,
                                                    surfaceShader: surfaceShader,
                                                    geometryModifier: nil) // No geometry modifier needed.
            return customMaterial
        } catch {
            print("Error creating custom material: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func createCustomOutlineMaterial(baseTint: UIColor = .white) -> CustomMaterial? {
            // Create a base PBR material.
            var baseMaterial = PhysicallyBasedMaterial()
            // You can adjust blending properties if needed.
            baseMaterial.blending = .transparent(opacity: 1.0)
            baseMaterial.opacityThreshold = 0.0
            
            // Set the base tint (this value will be passed to the shader).
            // In RealityKit, material constants are set based on the underlying material.
            // One way to modify these constants is by updating the baseColor tint.
            baseMaterial.baseColor.tint = baseTint
            
            // Get the default Metal device and library.
            guard let device = MTLCreateSystemDefaultDevice(),
                  let library = device.makeDefaultLibrary() else {
                print("Error: Unable to create Metal device or default library.")
                return nil
            }
            
            // Create a surface shader from our custom shader function.
            let surfaceShader = CustomMaterial.SurfaceShader(named: "customOutlineShader", in: library)
            
            // Create and return the custom material.
            do {
                let customMaterial = try CustomMaterial(from: baseMaterial,
                                                        surfaceShader: surfaceShader,
                                                        geometryModifier: nil) // No geometry modifier needed.
                return customMaterial
            } catch {
                print("Error creating custom material: \(error.localizedDescription)")
                return nil
            }
        }
    
    static func createPBRMaterial(color: UIColor, normal: String, opacity: String) -> PhysicallyBasedMaterial {
        var material = PhysicallyBasedMaterial()
        
        // Set the base color using a solid color (with no texture).
        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: color, texture: nil)
        
        // Load and assign the normal map texture.
        if let normalResource = try? TextureResource.load(named: normal) {
            let normalTexture = MaterialParameters.Texture(normalResource)
            material.normal = PhysicallyBasedMaterial.Normal(texture: normalTexture)
            // Apply tiling (repeat) on the primary texture coordinates.
            // This affects all textures using the primary UV channel (in this case, the normal map).
            material.secondaryTextureCoordinateTransform = .init(scale: SIMD2<Float>(4.0, 4.0))
        } else {
            material.normal = .init(texture: nil)
            print("Error: Unable to load normal texture named \(normal).")
        }
        
        // Set metalness to 0.3 and roughness to 0.3.
        material.metallic = PhysicallyBasedMaterial.Metallic(0.3)
        material.roughness = PhysicallyBasedMaterial.Roughness(0.3)
        
        // Load and assign the opacity texture.
        if let opacityResource = try? TextureResource.load(named: opacity) {
            let opacityTexture = MaterialParameters.Texture(opacityResource)
            let opacityValue = PhysicallyBasedMaterial.Opacity(scale: 1, texture: opacityTexture)
            material.blending = .transparent(opacity: opacityValue)
            material.emissiveColor = .init(texture: opacityTexture)
        } else {
            material.blending = .opaque
            print("Error: Unable to load opacity texture named \(opacity).")
        }
        
        return material
    }
    
//    static func loadCustomMaterial() -> CustomMaterial? {
//        guard let device = MTLCreateSystemDefaultDevice() else {
//            fatalError("Error creating default metal device.")
//        }
//
//
//        // Get a reference to the Metal library.
//        guard let library = device.makeDefaultLibrary() else {
//            return nil
//        }
//
//
//        // Load a geometry modifier function named myGeometryModifier.
//        let geometryModifier = CustomMaterial.GeometryModifier(named: "myGeometryModifier",
//                                                               in: library)
//
//
//        // Load a surface shader function named mySurfaceShader.
//        let surfaceShader = CustomMaterial.SurfaceShader(named: "mySurfaceShader",
//                                                         in: library)
//        
//        let customMaterial: CustomMaterial
//        do {
//            try customMaterial = CustomMaterial(from: <#T##any Material#>, surfaceShader: <#T##CustomMaterial.SurfaceShader#>)
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//
//        return customMaterial
//    }
}
