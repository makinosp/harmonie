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

    init() {
        appVM = AppViewModel()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appVM)
                .environmentObject(FavoriteViewModel(client: appVM.client))
                .environmentObject(FriendViewModel(appVM: appVM))
        }
    }
}
