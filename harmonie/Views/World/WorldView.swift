//
//  WorldView.swift
//  Harmonie
//
//  Created by xili on 2024/09/13.
//

import AsyncSwiftUI
import NukeUI
import VRCKit

private extension OptionalISO8601Date {
    var formatted: String {
        date?.formatted(date: .numeric, time: .omitted) ?? "Unknown"
    }
}

private extension Optional<Int> {
    var unwrappedValue: Int { self ?? 0 }
    var text: String { unwrappedValue.description }
}

private extension Int {
    var text: String { description }
}

extension LabelItem: View {
    var body: some View {
        VStack {
            VStack(spacing: 2) {
                Image(systemName: systemName)
                Text(caption)
                    .font(.caption)
            }
            .foregroundStyle(Color.accentColor)
            Text(value.description)
                .font(fontSize)
        }
        .frame(maxWidth: .infinity)
    }
}


struct WorldView: View {
    @Environment(AppViewModel.self) var appVM
    @Environment(FavoriteViewModel.self) var favoriteVM
    @State var world: World
    @State var isRequesting = false
    private let headerHeight: CGFloat = 250

    var topItems: [LabelItem] {
        [
            LabelItem(value: world.visits.text, caption: "Visits", systemName: IconSet.eye.systemName),
            LabelItem(value: world.favorites.text, caption: "Favorites", systemName: IconSet.favoriteFilled.systemName),
            LabelItem(value: world.popularity.text, caption: "Popularity", systemName: IconSet.heart.systemName)
        ]
    }

    var middleItems: [LabelItem] {
        [
            LabelItem(value: world.capacity.text, caption: "Capacity", systemName: IconSet.eye.systemName),
            LabelItem(value: world.occupants.text, caption: "Public", systemName: IconSet.social.systemName),
            LabelItem(value: world.privateOccupants.text, caption: "Private", systemName: IconSet.widebrim.systemName)
        ]
    }

    var bottomItems: [LabelItem] {
        [
            LabelItem(value: world.publicationDate.formatted, caption: "Published", systemName: IconSet.megaphone.systemName, fontSize: .footnote),
            LabelItem(value: world.updatedAt.formatted, caption: "Updated", systemName: IconSet.upload.systemName, fontSize: .footnote)
        ]
    }

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
            VStack(spacing: 12) {
                DividedHStack(alignment: .bottom) {
                    ForEach(topItems) { item in
                        detailItem(item)
                    }
                }
                Divider()
                DividedHStack(alignment: .bottom) {
                    ForEach(middleItems) { item in
                        detailItem(item)
                    }
                }
                Divider()
                DividedHStack(alignment: .bottom) {
                    ForEach(bottomItems) { item in
                        detailItem(item)
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
