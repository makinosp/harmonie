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
                VStack {
                    ForEach(FriendService.friendsGroupedByLocation(friendViewModel.onlineFriends)) { friendsLocation in
                        if friendsLocation.location != "private" && friendsLocation.location != "offline" && friendsLocation.location != "traveling" {
                            VStack {
                                LocationCardView(locationId: friendsLocation.location)
                                Text(friendsLocation.friends.count.description + "人")
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .navigationTitle("Locations")
        } detail: {
            EmptyView()
        }
    }
}

struct LocationCardView: View {
    @EnvironmentObject var userData: UserData
    @State var instance: Instance?
    let locationId: String
    let frameHeight: CGFloat = 100
    let frameWidth: CGFloat = 100

    var body: some View {
        if let instance = instance {
            VStack {
                LazyImage(url: URL(string: instance.world.imageUrl)) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: frameWidth, maxHeight: frameHeight)
                            .clipped()
                    } else if state.error != nil {
                        Image(systemName: "exclamationmark.circle")
                            .frame(maxWidth: frameWidth, maxHeight: frameHeight)
                    } else {
                        ZStack {
                            Color.clear
                                .frame(maxWidth: frameWidth, maxHeight: frameHeight)
                            ProgressView()
                        }
                    }
                }
                Text(instance.world.name)
            }
        } else {
            ZStack {
                Color.clear
                    .frame(height: frameHeight)
                ProgressView()
            }
            .task {
                do {
                    instance = try await InstanceService.fetchInstance(userData.client, location: locationId)
                } catch {
                    print(error)
                }
            }
        }
    }
}
