//
//  ContentView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/03.
//

import AsyncSwiftUI
import VRCKit

struct ContentView: View, AuthenticationServiceRepresentable, FriendServiceRepresentable {
    @Environment(AppViewModel.self) var appVM

    var body: some View {
        switch appVM.step {
        case .initializing:
            ProgressScreen()
                .task {
                    appVM.step = await appVM.setup(service: authenticationService)
                }
                .errorAlert()
        case .loggingIn:
            LoginView()
                .errorAlert()
        case .done(let user):
            MainTabView()
                .environment(FriendViewModel(user: user))
                .environment(FavoriteViewModel())
                .errorAlert()
        }
    }
}
