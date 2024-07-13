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
            let friendVM = FriendViewModel(
                appVM: appVM,
                service: appVM.isDemoMode ? FriendPreviewService(client: appVM.client) : FriendService(client: appVM.client)
            )
            let favoriteVM = FavoriteViewModel(
                appVM: appVM,
                friendVM: friendVM,
                service: FavoriteService(client: appVM.client)
            )
            MainTabView()
                .environmentObject(friendVM)
                .environmentObject(favoriteVM)
                .errorAlert()
        }
    }
}
