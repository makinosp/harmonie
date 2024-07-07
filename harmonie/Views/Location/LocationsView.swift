//
//  LocationsView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct LocationsView: View {
    @EnvironmentObject var friendVM: FriendViewModel
    let service: any FriendServiceProtocol

    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVStack {
                    ForEach(service.friendsGroupedByLocation(friendVM.onlineFriends)) { friendsLocation in
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
