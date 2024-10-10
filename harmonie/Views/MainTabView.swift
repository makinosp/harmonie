//
//  MainTabView.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/19.
//

import SwiftUI
import VRCKit

struct MainTabView: View, FriendServiceRepresentable, FavoriteServiceRepresentable {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel

    enum TabSegment: String, CaseIterable {
        case social, friends, favorites, settings
    }

    var body: some View {
        TabView {
            ForEach(TabSegment.allCases) { tabSegment in
                tabSegment.content
                    .tag(tabSegment)
                    .tabItem {
                        tabSegment.icon
                        Text(tabSegment.description)
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
                try await favoriteVM.fetchFavoriteFriends(
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

@MainActor
extension MainTabView.TabSegment {
    @ViewBuilder var content: some View {
        switch self {
        case .social: LocationsView()
        case .friends: FriendsView()
        case .favorites: FavoritesView()
        case .settings: SettingsView()
        }
    }

    @ViewBuilder var icon: some View {
        switch self {
        case .social: IconSet.location.icon
        case .friends: IconSet.friends.icon
        case .favorites: IconSet.favorite.icon
        case .settings: IconSet.setting.icon
        }
    }
}

extension MainTabView.TabSegment: CustomStringConvertible {
    var description: String {
        rawValue.capitalized
    }
}

extension MainTabView.TabSegment: Identifiable {
    var id: Int {
        hashValue
    }
}
