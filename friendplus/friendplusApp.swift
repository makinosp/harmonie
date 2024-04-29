//
//  FriendplusApp.swift
//  friendplus
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI

@main
struct FriendplusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserData())
        }
    }
}
