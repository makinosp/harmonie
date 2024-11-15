//
//  ContentView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/03.
//

import AsyncSwiftUI
import VRCKit

struct ContentView: View {
    @Environment(AppViewModel.self) var appVM
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel

    var body: some View {
        GeometricScreen {
            switch appVM.step {
            case .initializing:
                ProgressScreen()
                    .task { await setUpTask() }
            case .loggingIn:
                LoginView()
            case .done:
                MainTabView()
            }
        } action: { geometry in
            setScreenSize(geometry)
        }
        .errorAlert()
    }

    private func setUpTask() async {
        appVM.step = await appVM.setup(service: appVM.services.authenticationService)
    }

    private func setScreenSize(_ geometry: GeometryProxy) {
        appVM.screenSize = geometry.size
    }
}
