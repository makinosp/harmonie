//
//  MainTabView.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/19.
//

import SwiftUI
import VRCKit

struct MainTabView: View {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel

    var body: some View {
        TabView {
            LocationsView(appVM: appVM)
                .tabItem {
                    Image(systemName: Constants.IconName.loctaion)
                    Text("Locations")
                }
            FriendsView()
                .tabItem {
                    Image(systemName: Constants.IconName.friends)
                    Text("Friends")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: Constants.IconName.favoriteFilled)
                    Text("Favorites")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: Constants.IconName.setting)
                    Text("Settings")
                }
        }
        .task {
            do {
                try await friendVM.fetchAllFriends()
                try await favoriteVM.fetchFavorite(friendVM: friendVM)
            } catch {
                appVM.handleError(error)
            }
        }
    }
}
