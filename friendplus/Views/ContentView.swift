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
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
            }
        } else {
            ProgressView()
                .task {
                    await fetchUserData()
                }
        }
    }

    func fetchUserData() async {
        do {
            let isValidToken: Bool
            isValidToken = try await AuthenticationService.verifyAuthToken(userData.client)
            self.isValidToken = isValidToken
            guard isValidToken else { return }
            let response = try await AuthenticationService.loginUserInfo(userData.client)
            if case .user(let user) = response { userData.user = user }
        } catch {
            print(error)
        }
    }
}
