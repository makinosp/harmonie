//
//  LocationDetailView.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/17.
//

import AsyncSwiftUI
import NukeUI
import VRCKit

struct LocationDetailView: View {
    private let instance: Instance
    private let location: FriendsLocation

    init(instanceLocation: InstanceLocation) {
        instance = instanceLocation.instance
        location = instanceLocation.location
    }

    var body: some View {
        List {
            Section("World") {
                GradientOverlayImageView(
                    imageUrl: instance.world.imageUrl(.x1024),
                    thumbnailImageUrl: instance.world.imageUrl(.x256),
                    height: 80
                ) { bottomBar }
                    .listRowInsets(EdgeInsets())
            }
            Section("Friends") {
                friendList
            }
            Section("Information") {
                LabeledContent {
                    Text(instance.typeDescription)
                } label: {
                    Text("Instance Type")
                }
                LabeledContent {
                    Text(location.friends.count.description)
                } label: {
                    Text("Friends")
                }
                LabeledContent {
                    Text(instance.userCount.description)
                } label: {
                    Text("Users")
                }
                LabeledContent {
                    Text(instance.capacity.description)
                } label: {
                    Text("Capacity")
                }
                LabeledContent {
                    Text(instance.region.rawValue.uppercased())
                } label: {
                    Text("Region")
                }
                LabeledContent {
                    Text(instance.userPlatforms.map(\.description).joined(separator: ", "))
                } label: {
                    Text("Platform")
                }
            }
        }
        .navigationTitle(instance.world.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Selected.self) { selected in
            UserDetailPresentationView(selected: selected).id(selected)
        }
    }

    private var bottomBar: some View {
        VStack(alignment: .leading) {
            Text(instance.world.name)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .foregroundStyle(Color.white)
    }

    private var friendList: some View {
        ForEach(location.friends) { friend in
            NavigationLink(value: Selected(id: friend.id)) {
                Label {
                    Text(friend.displayName)
                } icon: {
                    UserIcon(user: friend, size: Constants.IconSize.thumbnail)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
        }
    }
}
