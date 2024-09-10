//
//  MainTabView.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/19.
//

import SwiftUI
import VRCKit

struct MainTabView: View, FriendServicePresentable, FavoriteServicePresentable {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel

    enum Tab: String, CaseIterable {
        case locations, friends, favorites, settings
    }

    var body: some View {
        TabView {
            ForEach(Tab.allCases) { tab in
                tab.content
                    .tag(tab)
                    .tabItem {
                        tab.icon
                        Text(tab.description)
                    }
            }
        }
        .task {
            do {
                defer { friendVM.isRequesting = false }
                try await friendVM.fetchAllFriends(service: friendService)
            } catch {
                appVM.handleError(error)
            }
            do {
                try await favoriteVM.fetchFavorite(
                    service: favoriteService,
                    friendVM: friendVM
                )
            } catch {
                appVM.handleError(error)
            }
        }
        .task {
            do {
                try await favoriteVM.fetchFavoritedWorlds(
                    service: appVM.isPreviewMode
                    ? WorldPreviewService(client: appVM.client)
                    : WorldService(client: appVM.client)
                )
            } catch {
                appVM.handleError(error)
            }
        }
    }
}

extension MainTabView.Tab {
    @ViewBuilder var content: some View {
        switch self {
        case .locations: LocationsView()
        case .friends: FriendsView()
        case .favorites: FavoritesView()
        case .settings: SettingsView()
        }
    }

    @ViewBuilder var icon: some View {
        switch self {
        case .locations: Constants.Icon.location
        case .friends: Constants.Icon.friends
        case .favorites: Constants.Icon.favorite
        case .settings: Constants.Icon.setting
        }
    }
}

extension MainTabView.Tab: CustomStringConvertible {
    var description: String {
        rawValue.capitalized
    }
}

extension MainTabView.Tab: Identifiable {
    var id: Int {
        hashValue
    }
}
