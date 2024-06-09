//
//  FriendDetailView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/16.
//

import AsyncSwiftUI
import NukeUI
import VRCKit

struct FriendDetailView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) private var dismiss
    @State var friend: UserDetail
    @State var instance: Instance?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                profileImage
                contentStacks
            }
        }
        .task {
            await fetchUser()
            await fetchInstance()
        }
    }

    var imageUrl: URL? {
        URL(string: (friend.userIcon.isEmpty ? friend.currentAvatarThumbnailImageUrl : friend.userIcon) ?? "")
    }

    var addedFavoriteGroupId: String? {
        userData.findOutFriendFromFavorites(friend.id)
    }

    var isAddedFavorite: Bool {
        addedFavoriteGroupId != nil
    }

    var profileImage: some View {
        LazyImage(url: imageUrl) { state in
            let gradient = Gradient(colors: [.black.opacity(0.5), .clear])
            if let image = state.image {
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
            } else if state.error != nil {
                Image(systemName: "exclamationmark.circle")
                    .frame(maxHeight: 250)
            } else {
                ZStack {
                    Color.clear
                        .frame(height: 250)
                    ProgressView()
                }
            }
        }
        .overlay(alignment: .top) {
            toolbar
        }
        .overlay(alignment: .bottom) {
            displayStatusAndName
        }
    }

    var toolbar: some View {
        HStack {
            Spacer()
            if let favoriteFriendGroups = userData.favoriteFriendGroups {
                favoriteMenu(favoriteFriendGroups)
            }
        }
        .foregroundStyle(Color.white)
        .padding(8)
    }

    func favoriteMenu(_ favoriteGroups: [FavoriteGroup]) -> some View {
        Menu {
            ForEach(favoriteGroups) { group in
                let isAddedFavoriteIn = userData.isIncludedFriendInFavorite(
                    friendId: friend.id,
                    groupId: group.id
                )
                AsyncButton {
                    await toggleFavorite(group: group)
                } label: {
                    Label {
                        Text(group.displayName)
                    } icon: {
                        if isAddedFavoriteIn {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: isAddedFavorite ? "star.fill" : "star")
                .font(.body)
        }
        .padding(8)
        .background {
            Circle()
                .foregroundStyle(Material.ultraThin)
        }
    }

    var displayStatusAndName: some View {
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

    var contentStacks: some View {
        VStack(spacing: 12) {
            if let instance = instance {
                locationSection(instance)
            }
            noteSection
            if let bio = friend.bio {
                bioSection(bio)
            }
            if let bioLinks = friend.bioLinks {
                let bioUrls = bioLinks.compactMap { URL(string: $0) }
                if !bioUrls.isEmpty {
                    bioLinksSection(bioUrls)
                }
            }
        }
        .padding()
    }

    func locationSection(_ instance: Instance) -> some View {
        HASection {
            Text("Location")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            Text(instance.world.name)
                .font(.body)
        }
    }

    var noteSection: some View {
        HASection {
            Text("Note")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            TextField("Enter note", text: $friend.note, axis: .vertical)
                .font(.body)
        }
    }

    func bioSection(_ bio: String) -> some View {
        HASection {
            Text("Bio")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            Text(bio)
                .font(.body)
        }
    }

    func bioLinksSection(_ urls: [URL]) -> some View {
        HASection {
            Text("Social Links")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            VStack(alignment: .leading) {
                ForEach(urls, id: \.self) { url in
                    Link(url.description, destination: url)
                        .font(.body)
                }
            }
        }
    }

    func fetchUser() async {
        do {
            friend = try await UserService.fetchUser(userData.client, userId: friend.id)
        } catch {
            print(error)
        }
    }

    func fetchInstance() async {
        do {
            instance = try await InstanceService.fetchInstance(userData.client, location: friend.location)
        } catch {
            print(error)
        }
    }

    func toggleFavorite(group: FavoriteGroup) async {
        do {
            if let addedFavoriteGroupId {
                let _ = try await FavoriteService.removeFavorite(
                    userData.client,
                    favoriteId: friend.id
                ).get()

                if !isAddedFavorite {
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
                    groupId: addedFavoriteGroupId
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

    func saveNote() async {
        do {
            let _ = try await UserNoteService.updateUserNote(
                userData.client,
                targetUserId: friend.id,
                note: friend.note
            )
        } catch {
            print(error)
        }
    }
}
