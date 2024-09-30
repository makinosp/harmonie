//
//  WorldView.swift
//  Harmonie
//
//  Created by xili on 2024/09/13.
//

import AsyncSwiftUI
import NukeUI
import VRCKit

extension WorldView: FavoriteServicePresentable {}
extension WorldView: InstanceServicePresentable {}

struct WorldView: View {
    @Environment(AppViewModel.self) var appVM
    @Environment(FavoriteViewModel.self) var favoriteVM
    @State var world: World
    @State var isRequesting = false

    var body: some View {
        ScrollView {
            VStack {
                GradientOverlayImageView(
                    imageUrl: world.imageUrl(.x1024),
                    thumbnailImageUrl: world.imageUrl(.x256),
                    height: 250,
                    topContent: { overlaysOnImage }
                )
                contentStacks
            }
        }
        .navigationTitle(world.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .toolbar { toolbar }
    }

    private var overlaysOnImage: some View {
        Label {
            Text(world.platform.explanation)
        } icon: {
            Image(systemName: "vision.pro.fill")
        }
        .font(.footnote.bold())
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(.thinMaterial)
        .cornerRadius(8)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

    private var contentStacks: some View {
        VStack {
            descriptionSection(world.description ?? "")
            authorSection
            detailsSection
        }
    }

    private func detailItem(
        value: String,
        systemName: String,
        caption: String
    ) -> some View {
        VStack {
            VStack(spacing: 2) {
                Image(systemName: systemName)
                Text(caption)
                    .font(.caption)
            }
            .foregroundStyle(Color.accentColor)
            Text(value)
        }
        .frame(maxWidth: .infinity)
    }

    private var detailsSection: some View {
        GroupBox("Details") {
            VStack(spacing: 12) {
                HStack(alignment: .bottom) {
                    detailItem(
                        value: world.visits.description,
                        systemName: "eye",
                        caption: "Visits"
                    )
                    Divider()
                    detailItem(
                        value: world.favorites?.description ?? "0",
                        systemName: "star.fill",
                        caption: "Favorites"
                    )
                    Divider()
                    detailItem(
                        value: world.popularity.description,
                        systemName: "heart.fill",
                        caption: "Popularity"
                    )
                    Divider()
                    detailItem(
                        value: world.heat.description,
                        systemName: "flame.fill",
                        caption: "Heat"
                    )
                }
                HStack(alignment: .bottom) {
                    detailItem(
                        value: world.capacity.description,
                        systemName: "person.3.fill",
                        caption: "Capacity"
                    )
                    Divider()
                    detailItem(
                        value: world.occupants?.description ?? "0",
                        systemName: "person.fill",
                        caption: "Public"
                    )
                    Divider()
                    detailItem(
                        value: world.privateOccupants?.description ?? "0",
                        systemName: "hat.widebrim.fill",
                        caption: "Private"
                    )
                }
                Divider()
                HStack(alignment: .bottom) {
                    detailItem(
                        value: world.publicationDate.date?.formatted(date: .numeric, time: .omitted) ?? "Unknown",
                        systemName: "megaphone.fill",
                        caption: "Published"
                    )
                    Divider()
                    detailItem(
                        value: world.updatedAt.formatted(date: .numeric, time: .omitted),
                        systemName: "icloud.and.arrow.up",
                        caption: "Updated"
                    )
                }
            }
        }
        .groupBoxStyle(.card)
    }

    private var authorSection: some View {
        GroupBox("Author") {
            Text(world.authorName)
                .font(.body)
        }
        .groupBoxStyle(.card)
    }

    private func descriptionSection(_ description: String) -> some View {
        GroupBox("Description") {
            Text(description)
                .font(.body)
        }
        .groupBoxStyle(.card)
    }
}

extension World.Platform {
    var explanation: LocalizedStringKey {
        switch self {
        case .android: "Quest Only"
        case .crossPlatform: "Cross-Platform"
        case .windows: "PC Only"
        case .none: "None"
        }
    }
}

#Preview {
    PreviewContainer {
        NavigationStack {
            WorldView(world: PreviewDataProvider.world)
        }
    }
}
