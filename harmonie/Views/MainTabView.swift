//
//  MainTabView.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/19.
//

import SwiftUI
import VRCKit

@MainActor
extension MainTabViewSegment {
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
        case .social: IconSet.social.icon
        case .friends: IconSet.friends.icon
        case .favorites: IconSet.favorite.icon
        case .settings: IconSet.setting.icon
        }
    }
}

struct MainTabView: View, FriendServiceRepresentable, FavoriteServiceRepresentable {
    @Environment(\.scenePhase) var scenePhase
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel

    var body: some View {
        TabView {
            ForEach(MainTabViewSegment.allCases) { tabSegment in
                tabSegment.content
                    .tag(tabSegment)
                    .tabItem {
                        tabSegment.icon
                        Text(tabSegment.description)
                    }
            }
        }
        .task { await fetchFriendsTask() }
        .task { await fetchFavoritesTask() }
        .onChange(of: appVM.user) { before, after in
            guard before != after else { return }
            Task { await fetchFriendsTask() }
            Task { await fetchFavoritesTask() }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                Task {
                    if await appVM.login() == nil { return }
                    appVM.step = .loggingIn
                }
            }
        }
    }

    private func fetchFriendsTask() async {
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

    private func fetchFavoritesTask() async {
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
