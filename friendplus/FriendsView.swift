//
//  FriendsView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct FriendsView: View {
    @State var friends: [Friend] = []
    var client: APIClientAsync

    init(client: APIClientAsync) {
        self.client = client
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Friends")
                .font(.largeTitle)
            ScrollView {
                LazyVStack {
                    ForEach(friends) { friend in
                        HStack {
                            // Thumbnail image
                            AsyncImage(
                                url: URL(string: friend.currentAvatarThumbnailImageUrl)
                            ) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            }

                            // Friend information
                            VStack(alignment: .leading) {
                                HStack(alignment: .bottom) {
                                    Text(friend.displayName)
                                        .font(.headline)
                                    Spacer()
                                    Text(friend.status)
                                        .font(.subheadline)
                                        .foregroundStyle(Color.gray)
                                }
                                if let bio = friend.bio {
                                    Text(bio)
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                }
            }
        }
        .padding()
        .task {
            do {
                friends = try await FriendService.fetchFriends(client, offline: true)
            } catch {

            }
        }
    }
}

//#Preview {
//    FriendsView(client: APIClientAsync())
//}
