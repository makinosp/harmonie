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

    init(world: World) {
        _world = State(initialValue: world)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let url = world.imageUrl(.x1024) {
                    profileImageContainer(url: url)
                }
                contentWorldStacks
            }
        }
        .navigationTitle(world.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
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
