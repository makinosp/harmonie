//
//  FriendplusApp.swift
//  friendplus
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI

var isPreview: Bool {
    ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

@main
struct FriendplusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserData())
        }
    }
}
