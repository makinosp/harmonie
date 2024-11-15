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
                        .errorAlert()
                }
            }
            .onChange(of: geometry) {
                setScreenSize(geometry)
            }
            .onAppear {
                setScreenSize(geometry)
            }
        }
        .onAppear {
            friendVM.setAppVM(appVM)
        }
    }

    private func setScreenSize(_ geometry: GeometryProxy) {
        appVM.screenSize = geometry.size
    }
}
