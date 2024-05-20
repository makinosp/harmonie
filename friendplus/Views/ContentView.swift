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
    @State var isValidToken: Bool?
    @State var isCompleted = false

    var body: some View {
        if let isValidToken = isValidToken, !isValidToken {
            LoginView(isValidToken: $isValidToken)
        } else if isCompleted {
            TabView {
                FriendsView()
                    .badge(userData.user?.onlineFriends.count ?? 0)
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
        } else {
            ProgressView()
                .onAppear {
                    Task {
                        await initialization()
                    }
                }
        }
    }

    func initialization() async {
        do {
            // verify auth token
            let isValidToken: Bool = try await AuthenticationService.verifyAuthToken(userData.client)
            self.isValidToken = isValidToken
            guard isValidToken else { return }

            // fetch user data
            switch try await AuthenticationService.loginUserInfo(userData.client) {
            case let value as User:
                userData.user = value
            case let value as [String]:
                break
            default:
                break
            }

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

            isCompleted = true
        } catch {
            print(error)
        }
    }
}
