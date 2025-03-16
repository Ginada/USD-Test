//
//  AnimationSystem.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-15.
//

import RealityKit
import Foundation

public struct AnimationSystem: System {
    
    // Define a query for entities with AnimationComponent.
    static let query = EntityQuery(where: .has(AnimationComponent.self))
    
    public init(scene: Scene) { }
    
    // This update method is called every frame.
    public func update(context: SceneUpdateContext) {
        let entities = context.scene.performQuery(Self.query)
        for entity in entities {
            guard let modelEntity = entity as? ModelEntity,
                  var animComp = entity.components[AnimationComponent.self] else {
                continue
            }
            
            // If no animation is running, start it.
            if animComp.playbackController == nil {
                let controller = modelEntity.playAnimation(animComp.currentClip.repeat(),
                                                           transitionDuration: animComp.transitionDuration,
                                                           startsPaused: false)
                animComp.playbackController = controller
                entity.components.set(animComp)
            }
        }
    }
    
    /// This helper method forces the playback of the clip on the given ModelEntity.
    func playAnimation(on entity: ModelEntity, transitionDuration: TimeInterval = 0.3) {
        if let clip = entity.availableAnimations.first {
            _ = entity.playAnimation(clip.repeat(), transitionDuration: transitionDuration, startsPaused: false)
        }
    }
    
    /// Helper to force-play the animation on all entities with an AnimationComponent.
    func playAnimationOnAllEntities(in scene: Scene, transitionDuration: TimeInterval = 0.3) {
        let entities = scene.performQuery(Self.query)
        for entity in entities {
            if let modelEntity = entity as? ModelEntity {
                playAnimation(on: modelEntity, transitionDuration: transitionDuration)
            }
        }
    }
}

struct AnimationComponent: Component {
    var currentClip: AnimationResource
    var transitionDuration: TimeInterval = 0.3
    var playbackController: AnimationPlaybackController?
}
