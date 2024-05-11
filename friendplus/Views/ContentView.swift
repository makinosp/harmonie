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

    var body: some View {
        if let isValidToken = isValidToken, !isValidToken {
            LoginView(isValidToken: $isValidToken)
        } else if userData.user != nil {
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
                        await fetchUserData()
                    }
                }
        }
    }

    func fetchUserData() async {
        do {
            // verify auth token
            let isValidToken: Bool = try await AuthenticationService.verifyAuthToken(userData.client)
            self.isValidToken = isValidToken
            guard isValidToken else { return }

            // user info
            switch try await AuthenticationService.loginUserInfo(userData.client) {
            case .user(let user):
                userData.user = user
            case .failure(let error):
                print(error)
            default:
                break
            }

            // favorite info
            switch try await FavoriteService.listFavoriteGroups(userData.client) {
            case .success(let favoriteGroups):
                userData.favoriteGroups = favoriteGroups
                do {
                    userData.favoriteFriendDetails = try await FavoriteService.fetchFriendsInGroups(
                        userData.client,
                        favorites: FavoriteService.fetchFavoriteGroupDetails(
                            userData.client,
                            favoriteGroups: favoriteGroups
                        )
                    )
                } catch {
                    print(error)
                }
            case .failure(let failure):
                print(failure)
            }
        } catch {
            print(error)
        }
    }
}
