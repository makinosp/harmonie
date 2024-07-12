//
//  HarmonieApp.swift
//  harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI

@main
struct HarmonieApp: App {
    let appVM: AppViewModel
    let friendVM: FriendViewModel
    let favoriteVM: FavoriteViewModel

    init() {
        appVM = AppViewModel()
        friendVM = FriendViewModel(appVM: appVM)
        favoriteVM = FavoriteViewModel(appVM: appVM, friendVM: friendVM)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appVM)
                .environmentObject(friendVM)
                .environmentObject(favoriteVM)
        }
    }
}
