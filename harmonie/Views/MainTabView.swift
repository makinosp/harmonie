//
//  MainTabView.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/19.
//

import SwiftUI
import VRCKit

struct MainTabView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel
    @AppStorage(Constants.Keys.tabSelection.rawValue) private var selection: MainTabViewSegment = .social
    @AppStorage(Constants.Keys.userData.rawValue) private var userData = ""

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
            scenePhaseHandler(scenePhase)
        }
    }
}

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
    var tab: some TabContent {
        Tab(description, systemImage: icon.systemName, value: self) { content }
    }
}

@MainActor
extension MainTabView {
    private func scenePhaseHandler(_ scenePhase: ScenePhase) {
        switch scenePhase {
        case .active:
            restoreUserData()
            Task { await fetchFriendsTask() }
            Task { await fetchFavoritesTask() }
        case .background, .inactive:
            guard let user = appVM.user else { return }
            userData = user.rawValue
        default: break
        }
    }

    private func restoreUserData() {
        guard let user = User(rawValue: userData) else { return }
        appVM.user = user
    }

    private var tabViewLegacy: some View {
        TabView(selection: $selection) {
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
        TabView(selection: $selection) {
            return ForEach(MainTabViewSegment.allCases) { $0.tab }
        }
        .tabViewStyle(.sidebarAdaptable)
    }

    private func fetchFriendsTask() async {
        do {
            try await friendVM.fetchAllFriends()
        } catch {
            appVM.handleError(error)
        }
        do {
            try await favoriteVM.fetchFavoriteFriends(
                service: appVM.services.favoriteService
            ) { favorite in
                friendVM.getFriend(id: favorite.favoriteId)
            }
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
