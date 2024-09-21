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
    @Binding var selectedUser: Selected?
    private let instance: Instance
    private let location: FriendsLocation

    init(instanceLocation: InstanceLocation, selectedUser: Binding<Selected?>) {
        instance = instanceLocation.instance
        location = instanceLocation.location
        _selectedUser = selectedUser
    }

    var body: some View {
        List(selection: $selectedUser) {
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
        .listStyle(.insetGrouped)
        .navigationTitle(instance.world.name)
        .navigationBarTitleDisplayMode(.inline)
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
            Label {
                LabeledContent {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        Constants.Icon.forward
                    }
                } label: {
                    Text(friend.displayName)
                }
            } icon: {
                UserIcon(user: friend, size: Constants.IconSize.thumbnail)
            }
            .tag(Selected(id: friend.id))
        }
    }
}
