//
//  World.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/28.
//

import Foundation
import VRCKit

extension PreviewData {
    static let bar = World(
        name: "Bar",
        description: "Bar",
        imageUrl: URL(string: "\(imageBaseURL)/7a/95/kLHkm3Ez_o.jpg"),
        favorites: 50,
        visits: 100,
        popularity: 10,
        heat: 4
    )

    static let chillRoom = World(
        name: "Chill Room",
        description: "Chill Room",
        imageUrl: URL(string: "\(imageBaseURL)/08/e0/LQFzWXox_o.jpeg"),
        favorites: 50,
        visits: 75,
        popularity: 5,
        heat: 3
    )

    static let fuji = World(
        name: "Mt. Fuji",
        description: "Mt. Fuji",
        imageUrl: URL(string: "\(imageBaseURL)/81/2f/MOoiKQgL_o.jpg"),
        favorites: 50,
        visits: 75,
        popularity: 5,
        heat: 3
    )

    static let chinatown = World(
        name: "Chinatown",
        description: "Chinatown",
        imageUrl: URL(string: "\(imageBaseURL)/08/64/vu7gTsyJ_o.jpg"),
        favorites: 50,
        visits: 75,
        popularity: 5,
        heat: 3
    )

    static let nightCity = World(
        name: "Night City",
        description: "Night City",
        imageUrl: URL(string: "\(imageBaseURL)/db/22/kolgI25s_o.jpg"),
        favorites: 50,
        visits: 75,
        popularity: 5,
        heat: 3
    )

    static let worldList = [ bar, chillRoom, fuji, chinatown, nightCity ]
}

extension World {
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        imageUrl: URL?,
        organization: String = "",
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
            thumbnailImageUrl: imageUrl,
            namespace: nil,
            organization: "",
            previewYoutubeId: nil,
            favorites: 1,
            createdAt: OptionalISO8601Date(),
            updatedAt: OptionalISO8601Date(),
            publicationDate: OptionalISO8601Date(),
            labsPublicationDate: OptionalISO8601Date(),
            visits: visits,
            popularity: popularity,
            heat: heat,
            version: 1,
            unityPackages: [
                UnityPackage(
                    id: UUID().uuidString,
                    assetVersion: 1,
                    createdAt: OptionalISO8601Date(),
                    platform: .standalonewindows,
                    unitySortNumber: 1,
                    unityVersion: ""
                )
            ],
            occupants: 0,
            privateOccupants: 0,
            publicOccupants: 0
        )
    }
}
