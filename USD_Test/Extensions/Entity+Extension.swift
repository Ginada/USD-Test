//
//  Entity+Extension.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-22.
//

import RealityKit

extension Entity {
    
        var allDescendants: [Entity] {
            var result = [Entity]()
            func addChildren(of entity: Entity) {
                for child in entity.children {
                    result.append(child)
                    addChildren(of: child)
                }
            }
            addChildren(of: self)
            return result
        }
    /// Returns all accessory ids found in descendant entity names,
    /// assuming each accessory name is formatted as "<assetID>_accessory".
    func activeAccessoryIDs() -> Set<String> {
            var ids = Set<String>()
            for descendant in self.allDescendants {
                if descendant.name.contains("_accessory") {
                    let components = descendant.name.split(separator: "_")
                    if let idComponent = components.first {
                        ids.insert(String(idComponent))
                    }
                }
            }
            return ids
        }
}
