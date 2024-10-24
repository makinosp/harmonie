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
        Instance(worldId: worldId, instanceId: instanceId)
    }

    static func instance() -> Instance {
        Instance(worldId: UUID(), instanceId: 0)
    }
}

private extension Instance {
    init(worldId: UUID, instanceId: Int) {
        self.init(
            active: true,
            capacity: 32,
            full: false,
            groupAccessType: nil,
            id: "wrld_\(worldId):\(instanceId)",
            instanceId: instanceId.description,
            location: .id("wrld_\(worldId.uuidString)"),
            name: "DummyInstance_\(instanceId)",
            ownerId: "usr_\(UUID().uuidString)",
            permanent: false,
            platforms: Platforms(),
            recommendedCapacity: 32,
            region: Region.allCases.randomElement() ?? .us,
            tags: [],
            type: [.public, .friends].randomElement() ?? .public,
            userCount: 0,
            world: PreviewDataProvider.generateWorld(worldId: worldId)
        )
    }
}
