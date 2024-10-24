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

    var label: Label<Text, Image> {
        Label(description, systemImage: icon.systemName)
    }

    @available(iOS 18, *)
    var tab: Tab<Never, some View, DefaultTabLabel> {
        Tab(description, systemImage: icon.systemName) { content }
    }
}

struct MainTabView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel

    var body: some View {
        Group {
            if #available(iOS 18, *) {
                tabView
            } else {
                tabViewLegacy
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

    private var tabViewLegacy: some View {
        TabView {
            ForEach(MainTabViewSegment.allCases) { tabSegment in
                tabSegment.content
                    .tag(tabSegment)
                    .tabItem {
                        tabSegment.label
                    }
            }
        }
    }

    @available(iOS 18, *) private var tabView: some View {
        TabView {
            ForEach(MainTabViewSegment.allCases) { $0.tab }
        }
        .tabViewStyle(.sidebarAdaptable)
    }

    private func fetchFriendsTask() async {
        do {
            defer { friendVM.isRequesting = false }
            try await friendVM.fetchAllFriends()
        } catch {
            appVM.handleError(error)
        }
        do {
            try await favoriteVM.fetchFavoriteFriends(
                service: appVM.services.favoriteService,
                friendVM: friendVM
            )
        } catch {
            appVM.handleError(error)
        }
    }

    private func fetchFavoritesTask() async {
        do {
            try await favoriteVM.fetchFavoritedWorlds(
                service: appVM.services.worldService
            )
        } catch {
            appVM.handleError(error)
        }
    }
}
