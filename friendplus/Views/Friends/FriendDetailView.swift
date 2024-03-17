//
//  FriendDetailView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct FriendDetailView: View {
    @State var friend: Friend

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(
                    url: URL(string: friend.currentAvatarThumbnailImageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                VStack {
                    Text(friend.displayName)
                        .font(.headline)
                    Text(friend.statusDescription)
                        .font(.body)
                }
                .padding()
                Text(friend.bio)
                    .font(.body)
                    .foregroundStyle(Color.gray)
                    .padding()
                Text(friend.lastLogin.description)
                if let bioLinks = friend.bioLinks {
                    ForEach(
                        Array(bioLinks.enumerated()),
                        id: \.element
                    ) { (index, urlString) in
                        if let url = URL(string: urlString) {
                            Link("Link \((index + 1).description)", destination: url)
                        }
                    }
                }
            }
        }
    }
}
