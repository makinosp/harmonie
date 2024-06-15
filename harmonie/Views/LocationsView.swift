//
//  LocationsView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/16.
//

import NukeUI
import SwiftUI
import VRCKit

struct LocationsView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var friendViewModel: FriendViewModel

    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVStack {
                    ForEach(FriendService.friendsGroupedByLocation(friendViewModel.onlineFriends)) { friendsLocation in
                        if friendsLocation.isVisible {
                            LocationCardView(location: friendsLocation)
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Locations")
        } detail: {
            EmptyView()
        }
    }
}

struct LocationCardView: View {
    @EnvironmentObject var userData: UserData
    @State var instance: Instance?
    let location: FriendsLocation
    let frameWidth: CGFloat = 120
    let iconSize = CGSize(width: 24, height: 24)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color(UIColor.secondarySystemGroupedBackground))
            if let instance = instance {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(instance.world.name)
                            .font(.body)
                        HStack {
                            Text(instance.type.rawValue)
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                            Spacer()
                            Text("\(location.friends.count.description) / \(instance.capacity.description)")
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                        }
                        ScrollView(.horizontal) {
                            HStack(spacing: 4) {
                                ForEach(location.friends) { friend in
                                    CircleURLImage(
                                        imageUrl: friend.userIconUrl,
                                        size: iconSize
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    LazyImage(url: URL(string: instance.world.imageUrl)) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: frameWidth)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else if state.error != nil {
                            Image(systemName: "exclamationmark.circle")
                                .frame(maxWidth: frameWidth)
                        } else {
                            ZStack {
                                Color.clear
                                    .frame(maxWidth: frameWidth)
                                ProgressView()
                            }
                        }
                    }
                    .padding()
                }
            } else { ProgressView() }
        }
        .frame(minHeight: 120)
        .task {
            do {
                instance = try await InstanceService.fetchInstance(
                    userData.client,
                    location: location.location
                )
            } catch {
                print(error)
            }
        }
    }
}
