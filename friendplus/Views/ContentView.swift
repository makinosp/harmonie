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
                }
            } else {
                LoginView()
            }
        } else {
            ProgressView()
                .task {
                    userData.client.updateCookies()
                    do {
                        isValidToken = try await AuthenticationService.verifyAuthToken(userData.client)
                    } catch {
                        print(error)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
