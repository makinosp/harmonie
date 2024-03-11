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
        if let isValidToken = isValidToken {
            if isValidToken {
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
                LoginView()
            }
        } else {
            ProgressView()
                .task {
                    do {
                        let isValidToken = try await AuthenticationService.verifyAuthToken(userData.client)
                        self.isValidToken = isValidToken
                        if isValidToken {
                            userData.user = try await AuthenticationService.loginUserInfo(userData.client).user
                        }
                    } catch {
                        print(error)
                    }
                }
        }
    }
}
