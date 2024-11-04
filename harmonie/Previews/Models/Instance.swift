//
//  Instance.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/21.
//

import Foundation
import VRCKit

extension PreviewData {
    static func instance(worldId: UUID, instanceId: Int) -> Instance {
        Instance(world: bar)
    }

    static var instance: Instance {
        Instance(world: bar)
    }

    static func instanceId(_ world: World) -> Instance.ID {
        "\(world.id):0"
    }

    static let instanceMap: [Instance.ID: Instance] = [
        instanceId(bar): Instance(world: bar, userCount: 25),
        instanceId(casino): Instance(world: casino, userCount: 25),
        instanceId(fuji): Instance(world: fuji, userCount: 25),
        instanceId(chinatown): Instance(world: chinatown, userCount: 25),
        instanceId(nightCity): Instance(world: nightCity, userCount: 25),
    ]
}

private extension Instance {
    init(world: World, instanceId: Int = 0, capacity: Int = 32, userCount: Int = 0) {
        self.init(
            active: true,
            capacity: capacity,
            full: false,
            groupAccessType: nil,
            id: "\(world.id):\(instanceId)",
            instanceId: instanceId.description,
            location: .id(world.id),
            name: world.name,
            ownerId: "usr_\(UUID().uuidString)",
            permanent: false,
            platforms: Platforms(),
            recommendedCapacity: capacity,
            region: Region.allCases.randomElement() ?? .us,
            tags: [],
            type: [.public, .friends].randomElement() ?? .public,
            userCount: userCount,
            world: world
        )
    }
}
