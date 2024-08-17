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
    let instance: Instance
    let location: FriendsLocation

    var body: some View {
        List {
            Section("World") {
                GradientOverlayImageView(
                    url: instance.world.imageUrl,
                    maxHeight: 160
                ) { bottomBar }
                    .listRowInsets(EdgeInsets())
            }
            Section("Friends") {
                friendList
            }
        }
        .navigationDestination(for: Selected.self) { selected in
            UserDetailPresentationView(id: selected.id)
                .id(selected.id)
        }
    }

    var bottomBar: some View {
        HStack {
            HStack(alignment: .bottom) {
                Text(instance.world.name)
                    .font(.headline)
                Text(instance.region.rawValue)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .foregroundStyle(Color.white)
    }

    var friendList: some View {
        ForEach(location.friends) { friend in
            NavigationLink(value: Selected(id: friend.id)) {
                HStack {
                    ZStack {
                        Circle()
                            .foregroundStyle(friend.status.color)
                            .frame(size: Constants.IconSize.thumbnailOutside)
                        CircleURLImage(
                            imageUrl: friend.userIconUrl,
                            size: Constants.IconSize.thumbnail
                        )
                    }
                    Text(friend.displayName)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
        }
    }
}
