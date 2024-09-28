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
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM
    @State var world: World

    var body: some View {
        ScrollView {
            VStack {
                GradientOverlayImageView(
                    imageUrl: world.imageUrl(.x1024),
                    thumbnailImageUrl: world.imageUrl(.x256),
                    height: 250,
                    bottomContent: { overlaysOnImage }
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
        VStack(alignment: .leading) {
            Text(world.name)
                .font(.headline)
        }
        .foregroundStyle(Color.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

    private var contentStacks: some View {
        VStack {
            authorSection
            if let description = world.description {
                descriptionSection(description)
            }
        }
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

#Preview {
    PreviewContainer {
        NavigationStack {
            WorldView(world: PreviewDataProvider.world)
        }
    }
}
