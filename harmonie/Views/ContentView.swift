//
//  ContentView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    @EnvironmentObject var friendViewModel: FriendViewModel

    var body: some View {
        switch userData.step {
        case .initializing, .loggedIn:
            HAProgressView()
                .task {
                    userData.step = await userData.initialization()
                }
                .alert(
                    isPresented: $userData.isPresentedAlert,
                    error: userData.vrckError
                ) { _ in
                    Button("OK") {
                        userData.logout()
                    }
                } message: { error in
                    Text(error.failureReason ?? "Try again later.")
                }
        case .loggingIn:
            LoginView()
        case .done:
            TabView {
                FriendsView()
                    .badge(userData.user?.onlineFriends.count ?? 0)
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Friends")
                    }
                LocationsView()
                    .tabItem {
                        Image(systemName: "location.fill")
                        Text("Locations")
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
            .task(priority: .background) {
                do {
                    try await favoriteViewModel.fetchFavorite()
                } catch {
                    userData.handleError(error)
                }
            }
            .task(priority: .background) {
                guard let count = userData.user?.onlineFriends.count else { return }
                do {
                    try await friendViewModel.fetchAllFriends(count: count)
                } catch {
                    userData.handleError(error)
                }
            }
            .alert(
                isPresented: $userData.isPresentedAlert,
                error: userData.vrckError
            ) { _ in
                Button("OK") {}
            } message: { error in
                Text(error.failureReason ?? "Try again later.")
            }
        }
    }
}
