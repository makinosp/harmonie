//
//  ContentView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @State var isPresentedAlert = false
    @State var vrckError: VRCKitError? = nil
    @State var step: Step = .initializing

    public enum Step: Equatable {
        case initializing
        case loggingIn
        case loggedIn
        case done(user: User)
    }

    var body: some View {
        switch step {
        case .initializing, .loggedIn:
            ProgressView()
                .controlSize(.large)
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
            LoginView(step: $step)
        case .done(let user):
            TabView {
                FriendsView()
                    .badge(user.onlineFriends.count)
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Friends")
                    }
//                LocationsView()
//                    .tabItem {
//                        Image(systemName: "location.fill")
//                        Text("Locations")
//                    }
                FavoritesView()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
            }
        }
    }

    func initialization() async {
        // check local data
        if userData.client.isEmptyCookies {
            step = .loggingIn
            return
        }
        do {
            // verify auth token
            guard try await AuthenticationService.verifyAuthToken(userData.client) else {
                step = .loggingIn
                return
            }

            // fetch user data
            switch try await AuthenticationService.loginUserInfo(userData.client) {
            case let value as User:
                userData.user = value

                // TODO: catch error
                // fetch favorite data
                switch try await FavoriteService.listFavoriteGroups(userData.client) {
                case .success(let favoriteGroups):
                    userData.favoriteGroups = favoriteGroups
                    let favorites = try await FavoriteService.fetchFavoriteGroupDetails(
                        userData.client,
                        favoriteGroups: favoriteGroups
                    )
                    userData.favoriteFriendDetails = try await FavoriteService.fetchFriendsInGroups(
                        userData.client,
                        favorites: favorites
                    )
                case .failure(let error):
                    print(error)
                }

                step = .done(user: value)
            case _ as [String]:
                step = .loggingIn
            default:
                unexpectedErrorOccurred()
            }
        } catch let error as VRCKitError {
            errorOccurred(error)
        } catch {
            unexpectedErrorOccurred()
        }
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
