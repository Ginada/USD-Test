//
//  FaceModel.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-14.
//

import Foundation
import RealityKit
import SwiftUI

class FaceModel: ObservableObject {
    
    /// The array of face model clones.
    @Published var clones: [ModelEntity] = []
    
    /// Loads the base face model and creates clones.
    init(cloneCount: Int = 2) {
        let baseFaceArmature = FaceModel.loadBaseFaceArmature()
        self.clones = FaceModel.createClones(from: baseFaceArmature, count: cloneCount)
        
        // Optionally, adjust blendshape weights on each clone.
        for clone in clones {
            FaceModel.adjustBlendShapeWeights(for: clone)
        }
        for i in 0...cloneCount - 1 {
            let randomColor: UIColor = [.red, .green, .blue, .yellow, .cyan, .magenta].randomElement()!
            let opacity = i == 0 ? "face_foun_214_blur" : "face_foun_184_blur"
            let material = MaterialManager.createCustomFaceMaterial(color: randomColor, normal: "eye_makeup_normal_sparcle", opacity: opacity)
            updateMaterial(forCloneAt: i, with: material!)
            clones[i].orientation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(1, 0, 0))
        }
    }
    
    /// Loads the base face model (the "Armature") from file.
    static func loadBaseFaceArmature() -> ModelEntity {
        guard let faceURL = Bundle.main.url(forResource: "model_makeup", withExtension: "usdc", subdirectory: "Art.scnassets/USD") else {
            fatalError("Unable to locate the face model in the bundle")
        }
        let faceEntity = try! Entity.load(contentsOf: faceURL)
        guard let faceArmature = faceEntity.findEntity(named: "Armature") as? ModelEntity else {
            fatalError("Face Armature not found")
        }
        // Optionally, you could keep the ModelComponent on the base to use as a source.
        return faceArmature
    }
    
    /// Creates a specified number of clones from the base ModelEntity.
    static func createClones(from base: ModelEntity, count: Int) -> [ModelEntity] {
        var clones: [ModelEntity] = []
        for _ in 0..<count {
            // Cloning recursively preserves the entire hierarchy (skeleton, blendshapes, etc.).
            let clone = base.clone(recursive: true)
            clones.append(clone)
        }
        return clones
    }
    
    /// Updates the material of a specific clone (by index) with a new material.
    func updateMaterial(forCloneAt index: Int, with material: RealityKit.Material) {
        guard index < clones.count else {
            print("Index \(index) out of range for face clones.")
            return
        }
        let clone = clones[index]
        // Retrieve and update the ModelComponent's materials array.
        if var modelComp = clone.components[ModelComponent.self] {
            modelComp.materials = [material]
            clone.components.set(modelComp)
        }
    }
    
    /// Optionally, play the shared animation (from your AnimationLibrary) on all clones.
    func playAnimation(transitionDuration: TimeInterval = 0.3) {
        if let clip = AnimationLibrary.shared.animation(for: "idle") {
            for clone in clones {
                clone.playAnimation(clip, transitionDuration: transitionDuration, startsPaused: false)
            }
        } else {
            print("Shared animation clip not available.")
        }
    }
    
    /// (Optional) Helper function to adjust blendshape weights.
    private static func adjustBlendShapeWeights(for model: ModelEntity) {
        if var blendShape = model.components[BlendShapeWeightsComponent.self] {
            var currentWeights = blendShape.weightSet[0].weights
            if currentWeights.count >= 4 {
                currentWeights[0] = 0.8
                currentWeights[1] = 0.8
                currentWeights[2] = 0.8
                currentWeights[3] = 0.8
            }
            if currentWeights.count > 20 { currentWeights[20] = 0.8 }
            if currentWeights.count > 29 { currentWeights[29] = 0.8 }
            if currentWeights.count > 32 { currentWeights[32] = 0.8 }
            blendShape.weightSet[0].weights = currentWeights
            model.components.set(blendShape)
        }
    }
}
