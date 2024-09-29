//
//  World.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/28.
//

import Foundation
import VRCKit

extension PreviewDataProvider {
    static var world: World {
        generateWorld(worldId: UUID())
    }

    static func generateWorld(worldId: UUID) -> World {
        World(
            id: worldId,
            name: "Dummy World",
            description: "Dummy World",
            imageUrl: Const.privateWorldImageUrl,
            thumbnailImageUrl: Const.privateWorldImageUrl,
            organization: "",
            favorites: 1,
            visits: 1,
            popularity: 1,
            heat: 1
        )
    }
}

extension World {
    init(
        id: UUID,
        name: String,
        description: String,
        imageUrl: URL?,
        thumbnailImageUrl: URL?,
        organization: String,
        favorites: Int,
        visits: Int,
        popularity: Int,
        heat: Int
    ) {
        self.init(
            id: "wrld_\(id.uuidString)",
            name: name,
            description: description,
            featured: true,
            authorId: "usr_\(UUID().uuidString)",
            authorName: "Author",
            capacity: 32,
            tags: [],
            releaseStatus: .public,
            imageUrl: imageUrl,
            thumbnailImageUrl: thumbnailImageUrl,
            namespace: nil,
            organization: "",
            previewYoutubeId: nil,
            favorites: 1,
            createdAt: Date(),
            updatedAt: Date(),
            publicationDate: OptionalISO8601Date(),
            labsPublicationDate: OptionalISO8601Date(),
            visits: visits,
            popularity: popularity,
            heat: heat,
            version: 1,
            unityPackages: [
                UnityPackage(
                    id: UUID().uuidString,
                    assetUrl: nil,
                    assetVersion: 1,
                    createdAt: Date(),
                    platform: .standalonewindows,
                    unitySortNumber: 1,
                    unityVersion: ""
                )
            ]
        )
    }
}
