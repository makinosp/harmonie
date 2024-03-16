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
            LoginView()
        } else if userData.user != nil {
            TabView {
                FriendsView()
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Friends")
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
        typealias authentication = AuthenticationService
        do {
            guard try await authentication.verifyAuthToken(userData.client) else {
                isValidToken = false
                return
            }
            userData.user = try await authentication.loginUserInfo(userData.client).user
        } catch {
            print(error)
        }
    }
}
