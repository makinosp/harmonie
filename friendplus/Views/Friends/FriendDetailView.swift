//
//  FriendDetailView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct FriendDetailView: View {
    @EnvironmentObject var userData: UserData
    @State var friend: UserDetail

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(
                    url: URL(string: friend.currentAvatarThumbnailImageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay {
                                LinearGradient(
                                    gradient: Gradient(colors: [.black.opacity(0.5), .clear]),
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            }
                            .overlay(alignment: .top) {
                                toolbar
                            }
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
                if let bio = friend.bio {
                    Text(bio)
                        .font(.body)
                        .foregroundStyle(Color.gray)
                        .padding()
                }
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
                HStack {
                    Image(systemName: "text.bubble")
                        .foregroundStyle(Color.gray)
                    TextEditor(text: $friend.note)
                }
                .padding()
            }
        }
        .background(.bar)
        .task {
            do {
                friend = try await UserService.fetchUser(userData.client, userId: friend.id)
            } catch {
                print(error)
            }
        }
    }

    var toolbar: some View {
        HStack {
            Spacer()
            Button {
                // action
            } label: {
                Image(systemName: "star")
                    .font(.title2)
                    .foregroundStyle(Color.white)
            }
        }
        .padding()
    }
}
