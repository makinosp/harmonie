//
//  WorldPreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/09/09.
//

import VRCKit

final actor WorldPreviewService: APIService, WorldServiceProtocol {
    let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func fetchWorld(worldId: String) async throws -> World {
        PreviewDataProvider.world
    }

    func fetchFavoritedWorlds(n: Int = 100) async throws -> [FavoriteWorld] {
        (0..<n).map { number in
            FavoriteWorld(
                world: PreviewDataProvider.world,
                favoriteGroup: number.description
            )
        }
    }
}
