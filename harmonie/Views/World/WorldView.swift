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
