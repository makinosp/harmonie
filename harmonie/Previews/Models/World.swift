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
        id: UUID(),
        name: "Bar",
        description: "Bar",
        imageUrl: URL(string: "\(imageBaseURL)/7a/95/kLHkm3Ez_o.jpg"),
        thumbnailImageUrl: URL(string: "\(imageBaseURL)/7a/95/kLHkm3Ez_o.jpg"),
        organization: "",
        favorites: 50,
        visits: 100,
        popularity: 10,
        heat: 4
    )

    static let casino = World(
        id: UUID(),
        name: "Casino",
        description: "Casino",
        imageUrl: URL(string: "\(imageBaseURL)/83/48/NtBOJpF1_o.jpg"),
        thumbnailImageUrl: URL(string: "\(imageBaseURL)/83/48/NtBOJpF1_o.jpg"),
        organization: "",
        favorites: 50,
        visits: 75,
        popularity: 5,
        heat: 3
    )
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
                    assetUrl: SafeDecoding(),
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
