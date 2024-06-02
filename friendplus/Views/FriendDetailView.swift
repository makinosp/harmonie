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
    @Environment(\.dismiss) private var dismiss
    @State var friend: UserDetail
    @State var isAppearedNote = false

    var body: some View {
        ScrollView {
            VStack {
                profileImage
                contentDetail
            }
        }
        .task {
            do {
                friend = try await UserService.fetchUser(userData.client, userId: friend.id).get()
            } catch {
                print(error)
            }
        }
        .sheet(isPresented: $isAppearedNote) {
            noteEditor
                .presentationDetents([.medium])
        }
    }

    var imageUrl: URL? {
        URL(string: friend.userIcon.isEmpty ? friend.thumbnailUrl : friend.userIcon)
    }

    var profileImage: some View {
        AsyncImage(url: imageUrl) { image in
            let gradient = Gradient(colors: [.black.opacity(0.5), .clear])
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxHeight: 250)
                .clipped()
                .overlay {
                    LinearGradient(
                        gradient: gradient,
                        startPoint: .top,
                        endPoint: .center
                    )
                }
                .overlay {
                    LinearGradient(
                        gradient: gradient,
                        startPoint: .bottom,
                        endPoint: .center
                    )
                }
        } placeholder: {
            ZStack {
                Color.clear
                    .frame(height: 250)
                ProgressView()
                    .controlSize(.large)
            }
        }
        .overlay(alignment: .top) {
            toolbar
        }
        .overlay(alignment: .bottom) {
            displayNameAndStatus
        }
    }

    var toolbar: some View {
        HStack {
            Spacer()
            favoriteButton
        }
        .font(.title3)
        .foregroundStyle(Color.white)
        .padding()
    }

    @ViewBuilder var favoriteButton: some View {
        let addedGroupId = userData.findOutFriendFromFavorites(friend.id)
        let isAdded = addedGroupId != nil
        if let favoriteFriendGroups = userData.favoriteFriendGroups {
            Menu {
                ForEach(favoriteFriendGroups) { group in
                    let isAddedIn = userData.isIncludedFriendInFavorite(
                        friendId: friend.id,
                        groupId: group.id
                    )
                    Button {
                        Task {
                            do {
                                if let addedGroupId {
                                    let _ = try await FavoriteService.removeFavorite(
                                        userData.client,
                                        favoriteId: friend.id
                                    ).get()

                                    if !isAddedIn {
                                        let _ = try await FavoriteService.addFavorite(
                                            userData.client,
                                            type: .friend,
                                            favoriteId: friend.id,
                                            tag: group.name
                                        ).get()
                                        userData.addFriendInFavorite(friend: friend, groupId: group.id)
                                    }

                                    userData.removeFriendFromFavorite(
                                        friendId: friend.id,
                                        groupId: addedGroupId
                                    )
                                } else {
                                    let _ = try await FavoriteService.addFavorite(
                                        userData.client,
                                        type: .friend,
                                        favoriteId: friend.id,
                                        tag: group.name
                                    ).get()
                                    userData.addFriendInFavorite(friend: friend, groupId: group.id)
                                }
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Label {
                            Text(group.displayName)
                        } icon: {
                            if isAddedIn {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: isAdded ? "star.fill" : "star")
            }
        }
    }

    var displayNameAndStatus: some View {
        HStack(alignment: .bottom) {
            Label {
                Text(friend.displayName)
            } icon: {
                Image(systemName: "circle.fill")
                    .foregroundStyle(StatusColor.statusColor(friend.status))
            }
            .font(.headline)
            Text(friend.statusDescription)
                .font(.subheadline)
            Spacer()
        }
        .foregroundStyle(Color.white)
        .padding()
    }

    var contentDetail: some View {
        VStack(spacing: 8) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Note")
                    Image(systemName: "square.and.pencil")
                }
                .font(.subheadline)
                .foregroundStyle(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(friend.note)
                    .font(.body)
                    .padding(.horizontal, 8)
            }
            .onTapGesture {
                isAppearedNote = true
            }

            VStack(alignment: .leading) {
                Text("Bio")
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let bio = friend.bio {
                    Text(bio)
                        .font(.body)
                        .padding(.horizontal, 8)
                }
            }

            VStack(alignment: .leading) {
                Text("Links")
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let bioLinks = friend.bioLinks {
                    ForEach(
                        Array(bioLinks.enumerated()),
                        id: \.element
                    ) { (index, urlString) in
                        if let url = URL(string: urlString) {
                            Link(urlString, destination: url)
                                .font(.body)
                                .padding(.horizontal, 8)
                        }
                    }
                }
            }
        }
        .padding()
    }

    var noteEditor: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    isAppearedNote = false
                }
                Spacer()
                Button("Save") {
                    Task {
                        do {
                            let _ = try await UserNoteService.updateUserNote(
                                userData.client,
                                targetUserId: friend.id,
                                note: friend.note
                            )
                            isAppearedNote = false
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            TextEditor(text: $friend.note)
                .scrollContentBackground(Visibility.hidden)
                .backgroundStyle(.ultraThinMaterial)
                .overlay(alignment: .topLeading) {
                    if friend.note.isEmpty {
                        Text("Enter note")
                            .foregroundStyle(Color(uiColor: .placeholderText))
                            .allowsHitTesting(false)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 5)
                    }
                }
        }
        .padding()
        .backgroundStyle(.ultraThinMaterial)
    }
}
