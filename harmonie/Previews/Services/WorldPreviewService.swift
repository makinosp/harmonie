//
//  WorldPreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/09/09.
//

import Foundation
import MemberwiseInit
import VRCKit

@MemberwiseInit
final actor WorldPreviewService: APIService, WorldServiceProtocol {
    let client: APIClient

    func fetchWorld(worldId: String) async throws -> World {
        PreviewData.worldList.first { $0.id == worldId } ?? PreviewData.bar
    }

    func fetchFavoritedWorlds() async throws -> [FavoriteWorld] {
        (0..<100).map { number in
            FavoriteWorld(
                world: PreviewData.casino,
                favoriteId: "fvrt_\(UUID())",
                favoriteGroup: number.description
            )
        }
    }

    func fetchFavoritedWorlds(n: Int, offset: Int) async throws -> [FavoriteWorld] {
        // No implementation required
        []
    }
}
