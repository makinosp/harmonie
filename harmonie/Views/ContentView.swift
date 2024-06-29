//
//  ContentView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/03.
//

import AsyncSwiftUI
import VRCKit

struct ContentView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @EnvironmentObject var friendVM: FriendViewModel

    var body: some View {
        switch appVM.step {
        case .initializing:
            ProgressScreen()
                .task {
                    appVM.step = await appVM.setup()
                }
                .errorAlert {
                    Task { await appVM.logout() }
                }
        case .loggingIn:
            LoginView()
                .errorAlert()
        case .done:
            MainTabView()
                .task {
                    async let fetchFavoriteTask: () = favoriteVM.fetchFavorite()
                    async let fetchAllFriendsTask: () = friendVM.fetchAllFriends()

                    do {
                        let _ = try await (fetchFavoriteTask, fetchAllFriendsTask)
                    } catch {
                        appVM.handleError(error)
                    }
                }
                .errorAlert()
        }
    }
}
