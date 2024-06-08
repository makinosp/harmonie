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
    @State var isPresentedAlert = false
    @State var vrckError: VRCKitError? = nil

    var body: some View {
        switch userData.step {
        case .initializing, .loggedIn:
            HAProgressView()
                .task {
                    await initialization()
                }
                .alert(isPresented: $isPresentedAlert, error: vrckError) { _ in
                    Button("OK") {
                        userData.logout()
                    }
                } message: { error in
                    Text(error.failureReason ?? "Try again later.")
                }
        case .loggingIn:
            LoginView()
        case .done(let user):
            TabView {
                FriendsView()
                    .badge(user.onlineFriends.count)
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
                    try await fetchFavorite()
                } catch let error as VRCKitError {
                    errorOccurred(error)
                } catch {
                    unexpectedErrorOccurred()
                }
            }
        }
    }

    func initialization() async {
        typealias Service = AuthenticationService
        // check local data
        if userData.client.isEmptyCookies {
            userData.step = .loggingIn
            return
        }
        do {
            // verify auth token
            guard try await Service.verifyAuthToken(userData.client) else {
                userData.step = .loggingIn
                return
            }
            // fetch user data
            switch try await Service.loginUserInfo(userData.client) {
            case let value as User:
                userData.user = value
                userData.step = .done(user: value)
            default:
                userData.step = .loggingIn
            }
        } catch let error as VRCKitError {
            errorOccurred(error)
        } catch {
            unexpectedErrorOccurred()
        }
    }

    // fetch favorite data
    func fetchFavorite() async throws {
        let favoriteGroups = try await FavoriteService.listFavoriteGroups(userData.client)
        userData.favoriteGroups = favoriteGroups
        let favorites = try await FavoriteService.fetchFavoriteGroupDetails(
            userData.client,
            favoriteGroups: favoriteGroups
        )
        userData.favoriteFriendDetails = try await FavoriteService.fetchFriendsInGroups(
            userData.client,
            favorites: favorites
        )
    }

    func errorOccurred(_ error: VRCKitError) {
        isPresentedAlert = true
        vrckError = error
    }

    func unexpectedErrorOccurred() {
        isPresentedAlert = true
        vrckError = .unexpectedError
    }
}
