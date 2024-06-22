//
//  MainTabView.swift
//  harmonie
//
//  Created by makinosp on 2024/06/19.
//

import SwiftUI
import VRCKit

struct MainTabView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    @EnvironmentObject var friendViewModel: FriendViewModel

    var body: some View {
        TabView {
            LocationsView()
                .badge(FriendService.friendsGroupedByLocation(friendViewModel.onlineFriends).count)
                .tabItem {
                    Image(systemName: "location.fill")
                    Text("Locations")
                }
            FriendsView()
                .badge(userData.user?.onlineFriends.count ?? 0)
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
