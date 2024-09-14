//
//  WorldDetailView.swift
//  Harmonie
//
//  Created by xili on 2024/09/13.
//

import AsyncSwiftUI
import NukeUI
import VRCKit

struct WorldDetailView: View, FavoriteServicePresentable, InstanceServicePresentable {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @State var world: World

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GradientOverlayImageView(
                    imageUrl: world.imageUrl(.x1024),
                    thumbnailImageUrl: world.imageUrl(.x256),
                    maxHeight: 250,
                    bottomContent: { overlaysOnImage }
                )
                contentWorldStacks
            }
        }
        .navigationTitle(world.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
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

    private var contentWorldStacks: some View {
        VStack(spacing: 12) {
            authorSection
            if let description = world.description {
                descriptionSection(description)
            }
        }
        .padding()
    }

    private var authorSection: some View {
        SectionView {
            Text("Author")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            Text(world.authorName)
                .font(.body)
        }
    }

    func descriptionSection(_ description: String) -> some View {
        SectionView {
            Text("Description")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            Text(description)
                .font(.body)
        }
    }
}
