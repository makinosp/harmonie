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

    var body: some View {
        GeometryReader { geometry in
            Group {
                switch appVM.step {
                case .initializing:
                    ProgressScreen()
                        .task {
                            appVM.step = await appVM.setup(service: appVM.services.authenticationService)
                        }
                        .errorAlert()
                case .loggingIn:
                    LoginView()
                        .errorAlert()
                case .done:
                    MainTabView()
                        .environment(FriendViewModel(appVM: appVM))
                        .environment(FavoriteViewModel())
                        .errorAlert()
                }
            }
            .onChange(of: geometry) {
                appVM.screenSize = geometry.size
            }
        }
    }
}
