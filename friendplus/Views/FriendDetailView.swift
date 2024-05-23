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
                VStack {
                    if let bio = friend.bio {
                        Text(bio)
                            .font(.callout)
                    }
                    if let bioLinks = friend.bioLinks {
                        ForEach(
                            Array(bioLinks.enumerated()),
                            id: \.element
                        ) { (index, urlString) in
                            if let url = URL(string: urlString) {
                                Link(urlString, destination: url)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .backgroundStyle(.ultraThinMaterial)
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

    var profileImage: some View {
        let imageUrl = friend.userIcon.isEmpty ? friend.currentAvatarThumbnailImageUrl : friend.userIcon
        return AsyncImage(
            url: URL(string: imageUrl)) { image in
                let gradient = Gradient(colors: [.black.opacity(0.5), .clear])
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
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
                    .overlay(alignment: .top) {
                        toolbar
                    }
                    .overlay(alignment: .bottom) {
                        displayNameAndStatus
                    }
            } placeholder: {
                ProgressView()
            }
    }

    var toolbar: some View {
        HStack {
            Spacer()
            noteButton
            favoriteButton
        }
        .font(.title3)
        .foregroundStyle(Color.white)
        .padding()
    }

    var noteButton: some View {
        Button {
            isAppearedNote.toggle()
        } label: {
            Image(systemName: friend.note.isEmpty ? "doc" : "doc.fill")
        }
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