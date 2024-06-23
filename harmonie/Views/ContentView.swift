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
                    AsyncButton("OK") {
                        await userData.logout()
                    }
                } message: { error in
                    Text(error.failureReason ?? "Try again later.")
                }
        case .loggingIn:
            LoginView()
        case .done:
            MainTabView()
                .task(priority: .low) {
                    async let fetchFavoriteTask: () = favoriteViewModel.fetchFavorite()
                    async let fetchAllFriendsTask: () = friendViewModel.fetchAllFriends()

                    do {
                        let _ = try await (fetchFavoriteTask, fetchAllFriendsTask)
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
