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
    
    static let shared = MaterialManager()
    private(set) var outlineMaterial: Material?
    
    private init() {
            loadMaterial()
        }
    
    private func loadMaterial() {
            // Load the USDZ asset containing your shader-graph material, or
            // call your helper function that creates the CustomMaterial.
            // For example, if you use a function like createCustomOutlineMaterial():
            self.outlineMaterial = loadShaderGraphMaterial()
    }
    
    func loadShaderGraphMaterial() -> Material? {
        do {
            let entity = try Entity.load(named: "Outline_material")
            // Assume your USDZ file contains one model entity with a custom material.
            if let modelEntity = entity.findEntity(named: "Sphere") as? ModelEntity,
               let material = modelEntity.model?.materials.first {
                return material
            }
        } catch {
            print("Failed to load shader-graph material: \(error)")
        }
        return nil
    }
    
    static func createPBRMaterial(texture: String, normal: String?, metalness: Float = 0.0, roughness: Float = 0.5, doubleSided: Bool = false, roughnessTexture: String? = nil, metalnessTexture: String? = nil, opacity: Float? = nil) -> PhysicallyBasedMaterial {
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
                //material.normal = .init(texture: nil)
               // print("Error: Unable to load normal texture named \(normal).")
            }
        }
        if let roughnessTexture = roughnessTexture {
            // Load and assign the roughness texture.
            if let roughnessResource = try? TextureResource.load(named: roughnessTexture) {
                let roughnessTexture = MaterialParameters.Texture(roughnessResource)
                material.roughness = PhysicallyBasedMaterial.Roughness(texture: roughnessTexture)
            } else {
                // Fallback: if roughness map fails, leave it unassigned (or provide a default if desired).
                //material.roughness = .init(texture: nil)
                print("Error: Unable to load roughness texture named \(roughnessTexture).")
            }
        } else {
            material.roughness = PhysicallyBasedMaterial.Roughness(floatLiteral: roughness)
        }
        
        if doubleSided {
            material.faceCulling = .none
        }
        if let metalnessTexture = metalnessTexture {
            // Load and assign the metalness texture.
            if let metalnessResource = try? TextureResource.load(named: metalnessTexture) {
                let metalnessTexture = MaterialParameters.Texture(metalnessResource)
                material.metallic = PhysicallyBasedMaterial.Metallic(texture: metalnessTexture)
            } else {
                // Fallback: if metalness map fails, leave it unassigned (or provide a default if desired).
                //material.metallic = .init(texture: nil)
                print("Error: Unable to load metalness texture named \(metalnessTexture).")
            }
        } else {
            material.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: metalness)
        }
        material.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: metalness)
       
        
        return material
    }
    
    static func transparentMaterial() -> PhysicallyBasedMaterial {
        var material = PhysicallyBasedMaterial()
        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: .black, texture: nil)
        material.blending = .transparent(opacity: 0.2)
        material.roughness = 0.1
        material.opacityThreshold = 0.1 // IMPORTANT
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
    
    static func makeupMaterial(color: UIColor, normal: String, opacity: Float, mask: String, roughness: Float, roughnessTexture: String?, metalness: Float) -> PhysicallyBasedMaterial {
        var material = PhysicallyBasedMaterial()
        if let opacityResource = try? TextureResource.load(named: mask) {
            let opacityTexture = MaterialParameters.Texture(opacityResource)
            let opacityValue = PhysicallyBasedMaterial.Opacity(scale: 1.0, texture: opacityTexture)
            material.blending = .transparent(opacity: opacityValue)
        } else {
            material.blending = .opaque
        }
        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: color, texture: nil)
        //material.blending = .transparent(opacity: 0.01)
        material.opacityThreshold = 0.0 // IMPORTANT
        if let roughnessTexture = roughnessTexture {
            if let roughnessResource = try? TextureResource.load(named: roughnessTexture) {
                let roughnessTexture = MaterialParameters.Texture(roughnessResource)
                material.roughness = PhysicallyBasedMaterial.Roughness(texture: roughnessTexture)
            } else {
                print("Error: Unable to load roughness texture named \(roughnessTexture).")
            }
        } else {
            material.roughness = PhysicallyBasedMaterial.Roughness(floatLiteral: roughness)
        }
            material.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: metalness)
            if let normalResource = try? TextureResource.load(named: normal) {
                let normalTexture = MaterialParameters.Texture(normalResource)
                material.normal = PhysicallyBasedMaterial.Normal(texture: normalTexture)
            }
        return material
    }

    static func createCustomFaceMaterial(color: UIColor, normal: String, opacity: Float, mask: String) -> CustomMaterial? {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Error creating default Metal device.")
        }
        guard let library = device.makeDefaultLibrary() else {
            return nil
        }
        
        // Create a base physically based material and configure its properties.
        var baseMaterial = MaterialManager.createPBRMaterial(color: color, normal: normal, opacity: opacity, mask: mask)
        baseMaterial.writesDepth = false
        let sheenColor = PhysicallyBasedMaterial.Color.black
        baseMaterial.sheen = .init(tint:sheenColor)
        baseMaterial.roughness = PhysicallyBasedMaterial.Roughness(0.0)
        //baseMaterial.blending = .transparent(opacity: 0.01)
        baseMaterial.opacityThreshold = 0.1
        // Load your opacity texture.
        
        // Create a custom binding for your opacity: this could be a uniform that you pass into your shader.
        
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
    
    static func outLineMaterial() -> Material {
        return MaterialManager.shared.outlineMaterial ?? PhysicallyBasedMaterial()
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
    
    static func createPBRMaterial(color: UIColor, normal: String, opacity: Float?, mask: String) -> PhysicallyBasedMaterial {
        var material = PhysicallyBasedMaterial()
        
        // Set the base color using a solid color (with no texture).
        material.baseColor = PhysicallyBasedMaterial.BaseColor(tint: color, texture: nil)
        
        // Load and assign the normal map texture.
        if let normalResource = try? TextureResource.load(named: normal) {
            let normalTexture = MaterialParameters.Texture(normalResource)
            material.normal = PhysicallyBasedMaterial.Normal(texture: normalTexture)
            // Apply tiling (repeat) on the primary texture coordinates.
            // This affects all textures using the primary UV channel (in this case, the normal map).
            material.secondaryTextureCoordinateTransform = .init(scale: SIMD2<Float>(1.0, 1.0))
        } else {
            material.normal = .init(texture: nil)
            print("Error: Unable to load normal texture named \(normal).")
        }
        
        // Set metalness to 0.3 and roughness to 0.3.
        material.metallic = PhysicallyBasedMaterial.Metallic(0.3)
        material.roughness = PhysicallyBasedMaterial.Roughness(0.3)
        
        // Load and assign the opacity texture.
        if let opacityResource = try? TextureResource.load(named: mask) {
            let opacityTexture = MaterialParameters.Texture(opacityResource)
            let opacityValue = PhysicallyBasedMaterial.Opacity(scale: opacity ?? 1.0, texture: opacityTexture)
            material.blending = .transparent(opacity: opacityValue)
            material.emissiveColor = .init(texture: opacityTexture)
        } else {
            material.blending = .opaque
            print("Error: Unable to load opacity texture named \(mask).")
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
