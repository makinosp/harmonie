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
    @EnvironmentObject var friendVM: FriendViewModel
    // @EnvironmentObject var favoriteVM: FavoriteViewModel

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
                    if appVM.demoMode {
                        friendVM.setDemoMode()
                    }
                    async let fetchAllFriendsTask: () = friendVM.fetchAllFriends()
                    // async let fetchFavoriteTask: () = favoriteVM.fetchFavorite()

                    do {
                        let _ = try await (fetchAllFriendsTask)
                    } catch {
                        appVM.handleError(error)
                    }
                }
                .errorAlert()
        }
    }
}
