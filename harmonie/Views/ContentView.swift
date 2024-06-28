//
//  ContentView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/03.
//

import AsyncSwiftUI
import VRCKit

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    @EnvironmentObject var friendViewModel: FriendViewModel

    var body: some View {
        switch userData.step {
        case .initializing:
            ProgressScreen()
                .task {
                    userData.step = await userData.setup()
                }
                .errorAlert {
                    Task { await userData.logout() }
                }
        case .loggingIn:
            LoginView()
                .errorAlert()
        case .done:
            MainTabView()
                .task {
                    async let fetchFavoriteTask: () = favoriteViewModel.fetchFavorite()
                    async let fetchAllFriendsTask: () = friendViewModel.fetchAllFriends()

                    do {
                        let _ = try await (fetchFavoriteTask, fetchAllFriendsTask)
                    } catch {
                        userData.handleError(error)
                    }
                }
                .errorAlert()
        }
    }
}
