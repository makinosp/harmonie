//
//  HarmonieApp.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI

@main
struct HarmonieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AppViewModel())
                .environment(FriendViewModel())
                .environment(FavoriteViewModel())
        }
    }
}
