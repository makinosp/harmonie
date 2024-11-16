//
//  WorldView.swift
//  Harmonie
//
//  Created by xili on 2024/09/13.
//

import AsyncSwiftUI
import NukeUI
import VRCKit

struct WorldView: View {
    @Environment(AppViewModel.self) var appVM
    @Environment(FavoriteViewModel.self) var favoriteVM
    @State var world: World
    @State var isRequesting = false
    private let headerHeight: CGFloat = 250

    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geometry in
                    GradientOverlayImageView(
                        imageUrl: world.imageUrl(.x1024),
                        thumbnailImageUrl: world.imageUrl(.x256),
                        size: CGSize(width: geometry.size.width, height: headerHeight),
                        topContent: { topOverlay },
                        bottomContent: { bottomOverlay }
                    )
                }
                .frame(height: headerHeight)
                contentStacks
            }
        }
        .navigationTitle(world.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .toolbar { toolbar }
    }

    private var topOverlay: some View {
        Label(world.platform.description, systemImage: IconSet.platform.systemName)
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

    private var bottomOverlay: some View {
        HStack(spacing: .zero) {
            ForEach(.zero..<world.heat, id: \.hashValue) { _ in
                Image(systemName: "flame.fill")
            }
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

    private func detailItem(_ item: LabelItem) -> some View {
        VStack {
            VStack(spacing: 2) {
                Image(systemName: item.systemName)
                Text(item.caption)
                    .font(.caption)
            }
            .foregroundStyle(Color.accentColor)
            Text(item.value)
                .font(item.fontSize)
        }
        .frame(maxWidth: .infinity)
    }

    private var detailsSection: some View {
        GroupBox("Details") {
            DividedVStack(spacing: 12) {
                ForEach(world.labelItemStacks) { labelItems in
                    DividedHStack(alignment: .bottom) {
                        ForEach(labelItems.items) { item in
                            detailItem(item)
                        }
                    }
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

#Preview {
    PreviewContainer {
        NavigationStack {
            WorldView(world: PreviewData.casino)
        }
    }
}
