//
//  ModelEntity+Extension.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-16.
//

import RealityKit

extension ModelEntity {
    func getJointIndex(suffix: String) -> Int? {
        return jointNames.enumerated().first { $0.element.hasSuffix(suffix) }?.offset
    }
}
