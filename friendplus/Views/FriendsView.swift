//
//  FriendsView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct FriendsView: View {
    @EnvironmentObject var userData: UserData
    @State var friends: [Friend]
    @State var selectedFriend: Friend? = nil

    let imageFrame = CGSize(width: 200, height: 150)
    let thumbnailFrame = CGSize(width: 32, height: 32)

    init(friends: [Friend] = []) {
        self.friends = friends
    }

    func filteredFriendsByStatus(_ status: FriendService.Status) -> [Friend] {
        friends.filter { $0.status == status.rawValue }
    }

    var body: some View {
        List {
            ForEach(FriendService.Status.allCases) { status in
                let filteredFriendsByStatus = filteredFriendsByStatus(status)
                if !filteredFriendsByStatus.isEmpty {
                    Section(header: Text(status.rawValue).textCase(.uppercase)) {
                        ForEach(filteredFriendsByStatus) { friend in
                            rowView(friend)
                        }
                    }
                }
            }
        }
        .listStyle(.inset)
        .sheet(item: $selectedFriend) { friend in
            detailView(friend)
                .presentationDetents([.medium, .large])
        }
        .task {
            do {
                friends = try await FriendService.fetchFriends(
                    userData.client,
                    offline: false
                )
            } catch {
                print(error)
            }
        }
    }

    /// Row view for friend list
    func rowView(_ friend: Friend) -> some View {
        HStack {
            AsyncImage(
                url: URL(string: friend.currentAvatarThumbnailImageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(size: thumbnailFrame)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(size: thumbnailFrame)
                }
            Text(friend.displayName)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedFriend = friend
        }
    }

    /// Friends detail view
    func detailView(_ friend: Friend) -> some View {
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
            }
        }
    }
}

#Preview {
    FriendsView(
        friends: [
            Friend(
                bio: "bio",
                bioLinks: ["https://twitter.com/makinovrc"],
                currentAvatarImageUrl: "https://api.vrchat.cloud/api/1/file/file_29cc0315-390e-44b1-b9f1-6eb7601ca5fd/2/file",
                currentAvatarThumbnailImageUrl: "https://api.vrchat.cloud/api/1/image/file_29cc0315-390e-44b1-b9f1-6eb7601ca5fd/2/256",
                developerType: "string",
                displayName: "displayName",
                id: UUID().uuidString,
                isFriend: true,
                lastLogin: Date(),
                lastPlatform: "lastPlatform",
                status: "online",
                statusDescription: "statusDescription",
                tags: ["tag"]
            )
        ]
    )
    .environmentObject(UserData())
}
