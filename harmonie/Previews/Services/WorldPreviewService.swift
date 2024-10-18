//
//  WorldPreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/09/09.
//

import Foundation
import VRCKit

final actor WorldPreviewService: APIService, WorldServiceProtocol {
    let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func fetchWorld(worldId: String) async throws -> World {
        PreviewDataProvider.world
    }

    func fetchFavoritedWorlds() async throws -> [FavoriteWorld] {
        (0..<100).map { number in
            FavoriteWorld(
                world: PreviewDataProvider.world,
                favoriteId: "fvrt_\(UUID())",
                favoriteGroup: number.description
            )
        }
    }
}
