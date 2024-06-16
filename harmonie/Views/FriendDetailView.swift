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
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    @Environment(\.dismiss) private var dismiss
    @State var friend: any ProfileDetailRepresentable
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
            if friend.isVisible {
                await fetchInstance()
            }
        }
    }

    var addedFavoriteGroupId: String? {
        favoriteViewModel.findOutFriendFromFavorites(friend.id)
    }

    var isAddedFavorite: Bool {
        addedFavoriteGroupId != nil
    }

    var profileImage: some View {
        LazyImage(url: friend.thumbnailUrl) { state in
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
        .overlay(alignment: .top) { topBar }
        .overlay(alignment: .bottom) { bottomBar }
    }

    var topBar: some View {
        HStack {
            Spacer()
            AsyncButton("Save") {
                await saveNote()
            }
            .foregroundStyle(Color.accentColor)
            .buttonStyle(.borderedProminent)
            .tint(Material.regularMaterial)
            .buttonBorderShape(.capsule)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

    var bottomBar: some View {
        HStack {
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
            }
            Spacer()
            if let favoriteFriendGroups = favoriteViewModel.favoriteFriendGroups {
                favoriteMenu(favoriteFriendGroups)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .foregroundStyle(Color.white)
    }

    func favoriteMenu(_ favoriteGroups: [FavoriteGroup]) -> some View {
        Menu {
            ForEach(favoriteGroups) { group in
                let isAddedFavoriteIn = favoriteViewModel.isIncludedFriendInFavorite(
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
                .frame(size: CGSize(width: 12, height: 12))
                .padding(12)
                .background {
                    Circle()
                        .foregroundStyle(Material.regularMaterial)
                }
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
        .padding(8)
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
//            TextField("Enter note", text: $friend.note, axis: .vertical)
//                .font(.body)
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
        guard let friend = friend as? UserDetail else { return }
        do {
            instance = try await InstanceService.fetchInstance(userData.client, location: friend.location)
        } catch {
            print(error)
        }
    }

    func toggleFavorite(group: FavoriteGroup) async {
        guard let friend = friend as? UserDetail else { return }
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
                    favoriteViewModel.addFriendInFavorite(friend: friend, groupId: group.id)
                }

                favoriteViewModel.removeFriendFromFavorite(
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
                favoriteViewModel.addFriendInFavorite(friend: friend, groupId: group.id)
            }
        } catch {
            print(error)
        }
    }

    func saveNote() async {
        guard let friend = friend as? UserDetail else { return }
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
