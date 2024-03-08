//
//  ContentView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct ContentView: View {
    @State var isValidToken: Bool?
    @State var client = APIClientAsync()

    var body: some View {
        if let isValidToken = isValidToken {
            if isValidToken {
                FriendsView(client: client)
            } else {
                LoginView(client: $client)
            }
        } else {
            ProgressView()
                .task {
                    client.updateCookies()
                    do {
                        isValidToken = try await AuthenticationService.verifyAuthToken(client)
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
