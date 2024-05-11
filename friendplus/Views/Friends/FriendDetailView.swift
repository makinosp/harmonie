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

    var noteEditor: some View {
        VStack {
            HStack {
                Button {
                    isAppearedNote = false
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
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
                } label: {
                    Text("Save")
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
            Button {
                isAppearedNote.toggle()
            } label: {
                Image(systemName: "doc.plaintext")
            }
            if let favoriteFriendGroups = userData.favoriteFriendGroups {
                Menu {
                    ForEach(favoriteFriendGroups) { group in
                        Button {
                            // TODO: Action
                        } label: {
                            Label {
                                Text(group.displayName)
                            } icon: {
                                if userData.isIncludedFriendInFavorite(friendId: friend.id, groupId: group.id) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    if userData.findOutFriendFromFavorites(friend.id) == nil {
                        Image(systemName: "star")
                    } else {
                        Image(systemName: "star.fill")
                    }
                }
            }
        }
        .font(.title3)
        .foregroundStyle(Color.white)
        .padding()
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
}
