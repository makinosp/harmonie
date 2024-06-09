//
//  HarmonieApp.swift
//  harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI

@main
struct HarmonieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserData())
                .environmentObject(FavoriteViewModel())
        }
    }
}
