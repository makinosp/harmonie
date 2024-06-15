//
//  LocationsView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/16.
//

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
