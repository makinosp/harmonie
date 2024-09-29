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
            if let description = world.description {
                descriptionSection(description)
            }
            authorSection
            detailsSection
        }
    }

    private var detailsSection: some View {
        GroupBox("Details") {
            LabeledContent {
                Text(world.visits.description)
            } label: {
                Label {
                    Text("Visits")
                } icon: {
                    Image(systemName: "eye")
                }
            }
            Divider()
            LabeledContent {
                Text(world.favorites?.description ?? "0")
            } label: {
                Label {
                    Text("Favorites")
                } icon: {
                    Constants.Icon.favoriteFilled
                }
            }
            Divider()
            LabeledContent {
                Text(world.capacity.description)
            } label: {
                Label {
                    Text("Capacity")
                } icon: {
                    Image(systemName: "person.3.fill")
                }
            }
            Divider()
            LabeledContent {
                Text(world.occupants?.description ?? "0")
            } label: {
                Label {
                    Text("Public Players")
                } icon: {
                    Image(systemName: "person.fill")
                }
            }
            Divider()
            LabeledContent {
                Text(world.privateOccupants?.description ?? "0")
            } label: {
                Label {
                    Text("Private Players")
                } icon: {
                    Image(systemName: "hat.widebrim.fill")
                }
            }
            Divider()
            LabeledContent {
                Text(world.publicationDate.date?.formatted(date: .complete, time: .complete) ?? "Unknown")
            } label: {
                Label {
                    Text("Published")
                } icon: {
                    Image(systemName: "megaphone.fill")
                }
            }
            Divider()
            LabeledContent {
                Text(world.updatedAt.formatted(date: .complete, time: .complete))
            } label: {
                Label {
                    Text("Updated")
                } icon: {
                    Image(systemName: "icloud.and.arrow.up")
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
