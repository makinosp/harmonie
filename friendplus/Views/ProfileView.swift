//
//  ProfileView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/10.
//

import SwiftUI
import VRCKit

struct ProfileView: View {
    @EnvironmentObject var userData: UserData

    var body: some View {
        if let user = userData.user {
            VStack {
                Text(user.displayName)
                    .font(.headline)
                Text(user.bio)
                    .font(.footnote)
            }
        } else {
            Text("Data Error")
        }
    }
}
