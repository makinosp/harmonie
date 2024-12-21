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
    @Environment(\.horizontalSizeClass) var defaultHorizontalSizeClass
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
        .onAppear {
            friendVM.setAppVM(appVM)
            Task { await fetchFriendsTask() }
            Task { await fetchFavoritesTask() }
        }
        .onChange(of: scenePhase) { before, after in
            changedScenePhaseHandler(before, after)
        }
        .onChange(of: favoriteVM.favoriteFriends) {
            friendVM.favoriteFriends = favoriteVM.favoriteFriends
        }
    }
}

@MainActor
private extension MainTabViewSegment {
    @ViewBuilder var content: some View {
        switch self {
        case .social: LocationsView()
        case .friends: FriendsView()
        case .favorites: FavoritesView()
        case .settings: SettingsView()
        }
    }
}

private extension MainTabView {
    private func changedScenePhaseHandler(_ before: ScenePhase, _ after: ScenePhase) {
        switch (before, after) {
        case (.background, .inactive):
            print("Restoring Data")
            restoreUserData()
            Task { await fetchFriendsTask() }
            Task { await fetchFavoritesTask() }
        case (.active, .inactive):
            let filterUserStatusStrings = Array(friendVM.filterUserStatus.map(\.rawValue))
            UserDefaults.standard.set(filterUserStatusStrings, forKey: "filterUserStatus")
            let favoriteGroupsIds = Array(friendVM.filterFavoriteGroups.map(\.id))
            UserDefaults.standard.set(favoriteGroupsIds, forKey: "filterFavoriteGroups")
            UserDefaults.standard.set(friendVM.sortType.rawValue, forKey: "sortType")
            guard let user = appVM.user else { return }
            userData = user.rawValue
        default: break
        }
    }

    private func restoreUserData() {
        guard let user = User(rawValue: userData) else { return }
        appVM.user = user
    }
}

@MainActor
private extension MainTabView {
    private var tabViewLegacy: some View {
        TabView(selection: $selection) {
            ForEach(MainTabViewSegment.allCases) { tabSegment in
                tabSegment.content
                    .tag(tabSegment)
                    .tabItem {
                        Label(
                            tabSegment.description,
                            systemImage: tabSegment.icon.systemName
                        )
                    }
            }
        }
    }

    @available(iOS 18, *) private var tabView: some View {
        TabView(selection: $selection) {
            ForEach(MainTabViewSegment.allCases) { segment in
                Tab(segment.description, systemImage: segment.icon.systemName, value: segment) {
                    segment.content.environment(\.horizontalSizeClass, defaultHorizontalSizeClass)
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .environment(\.horizontalSizeClass, .compact)
    }

    private func fetchFriendsTask() async {
        await friendVM.fetchAllFriends { error in
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
