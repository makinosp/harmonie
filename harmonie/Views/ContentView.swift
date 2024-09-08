//
//  ContentView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/03.
//

import AsyncSwiftUI
import VRCKit

struct ContentView: View, AuthenticationServicePresentable, FriendServicePresentable {
    @Environment(AppViewModel.self) var appVM: AppViewModel

    var body: some View {
        switch appVM.step {
        case .initializing:
            ProgressScreen()
                .task {
                    appVM.step = await appVM.setup(service: authenticationService)
                }
                .errorAlert {
                    Task { await appVM.logout(service: authenticationService) }
                }
        case .loggingIn:
            AuthenticationView()
                .errorAlert()
        case .done(let user):
            let friendVM = FriendViewModel(user: user)
            let favoriteVM = appVM.generateFavoriteVM(friendVM: friendVM)
            MainTabView()
                .environment(friendVM)
                .environment(favoriteVM)
                .errorAlert()
        }
    }
}
