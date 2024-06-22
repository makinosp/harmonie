//
//  HarmonieApp.swift
//  harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI

@main
struct HarmonieApp: App {
    let userData: UserData

    init() {
        self.userData = UserData()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userData)
                .environmentObject(FavoriteViewModel(client: userData.client))
                .environmentObject(FriendViewModel(client: userData.client, userData: userData))
        }
    }
}
