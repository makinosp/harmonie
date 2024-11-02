//
//  Instance.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/21.
//

import Foundation
import VRCKit

extension PreviewDataProvider {
    static func instance(worldId: UUID, instanceId: Int) -> Instance {
        Instance(world: bar)
    }

    static func instance() -> Instance {
        Instance(world: bar)
    }

    static let instance1 = Instance(world: bar)
}

private extension Instance {
    init(world: World, instanceId: Int = 0) {
        self.init(
            active: true,
            capacity: 32,
            full: false,
            groupAccessType: nil,
            id: "\(world.id):\(instanceId)",
            instanceId: instanceId.description,
            location: .id(world.id),
            name: world.name,
            ownerId: "usr_\(UUID().uuidString)",
            permanent: false,
            platforms: Platforms(),
            recommendedCapacity: 32,
            region: Region.allCases.randomElement() ?? .us,
            tags: [],
            type: [.public, .friends].randomElement() ?? .public,
            userCount: 0,
            world: world
        )
    }
}
