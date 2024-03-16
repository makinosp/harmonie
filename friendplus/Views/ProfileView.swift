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
                AsyncImage(
                    url: URL(string: user.currentAvatarImageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                Text(user.displayName)
                    .font(.headline)
                HStack {
                    Label("\(user.friends.count)", systemImage: "person.2")
                }
                Text(user.bio)
                    .font(.footnote)
            }
        } else {
            Label("Data Error", systemImage: "exclamationmark.triangle.fill")
        }
    }
}
