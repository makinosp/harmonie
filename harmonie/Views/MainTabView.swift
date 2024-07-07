//
//  MainTabView.swift
//  harmonie
//
//  Created by makinosp on 2024/06/19.
//

import SwiftUI
import VRCKit

struct MainTabView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var friendVM: FriendViewModel
    let friendService: any FriendServiceProtocol

    var body: some View {
        TabView {
            LocationsView(service: friendService)
                .badge(friendService.friendsGroupedByLocation(friendVM.onlineFriends).count)
                .tabItem {
                    Image(systemName: "location.fill")
                    Text("Locations")
                }
            FriendsView()
                .badge(appVM.user?.onlineFriends.count ?? 0)
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Friends")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}
