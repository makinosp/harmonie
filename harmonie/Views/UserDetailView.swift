//
//  UserDetailView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/16.
//

import AsyncSwiftUI
import NukeUI
import VRCKit

struct UserDetailView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    @Environment(\.dismiss) private var dismiss
    @State var user: UserDetail?
    @State var instance: Instance?
    let id: String

    var note: Binding<String?> {
        .init(
            get: { user?.note },
            set: { value in user?.note = value ?? "" }
        )
    }

    var body: some View {
        if let user = user {
            ScrollView {
                VStack(spacing: 0) {
                    profileImage(user)
                    contentStacks(user)
                }
            }
            .task {
                if user.isVisible {
                    await fetchInstance(user)
                }
            }
        } else {
            ProgressView()
                .task {
                    await fetchUser()
                }
        }
    }

    var addedFavoriteGroupId: String? {
        favoriteViewModel.findOutFriendFromFavorites(id)
    }

    var isAddedFavorite: Bool {
        addedFavoriteGroupId != nil
    }

    func profileImage(_ user: UserDetail) -> some View {
        LazyImage(url: user.thumbnailUrl) { state in
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
        .overlay(alignment: .top) { topBar(user) }
        .overlay(alignment: .bottom) { bottomBar(user) }
    }

    func topBar(_ user: UserDetail) -> some View {
        HStack {
            Spacer()
            AsyncButton("Save") {
                await saveNote(user)
            }
            .foregroundStyle(Color.accentColor)
            .buttonStyle(.borderedProminent)
            .tint(Material.regularMaterial)
            .buttonBorderShape(.capsule)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

    func bottomBar(_ user: UserDetail) -> some View {
        HStack {
            HStack(alignment: .bottom) {
                Label {
                    Text(user.displayName)
                } icon: {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(StatusColor.statusColor(user.status))
                }
                .font(.headline)
                Text(user.statusDescription)
                    .font(.subheadline)
            }
            Spacer()
            if let favoriteFriendGroups = favoriteViewModel.favoriteFriendGroups {
                favoriteMenu(user, favoriteFriendGroups)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .foregroundStyle(Color.white)
    }

    func favoriteMenu(_ user: UserDetail, _ favoriteGroups: [FavoriteGroup]) -> some View {
        Menu {
            ForEach(favoriteGroups) { group in
                let isAddedFavoriteIn = favoriteViewModel.isIncludedFriendInFavorite(
                    friendId: user.id,
                    groupId: group.id
                )
                AsyncButton {
                    await toggleFavorite(user, group: group)
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

    func displayStatusAndName(_ user: UserDetail) -> some View {
        HStack(alignment: .bottom) {
            Label {
                Text(user.displayName)
            } icon: {
                Image(systemName: "circle.fill")
                    .foregroundStyle(StatusColor.statusColor(user.status))
            }
            .font(.headline)
            Text(user.statusDescription)
                .font(.subheadline)
            Spacer()
        }
        .padding(8)
    }

    func contentStacks(_ user: UserDetail) -> some View {
        VStack(spacing: 12) {
            if let instance = instance {
                locationSection(instance)
            }
            noteSection
            if let bio = user.bio {
                bioSection(bio)
            }
            if let bioLinks = user.bioLinks {
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
            TextField("Enter note", text: note ?? "", axis: .vertical)
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
            user = try await UserService.fetchUser(userData.client, userId: id)
        } catch {
            print(error)
        }
    }

    func fetchInstance(_ user: UserDetail) async {
        do {
            instance = try await InstanceService.fetchInstance(
                userData.client,
                location: user.location
            )
        } catch {
            print(error)
        }
    }

    func toggleFavorite(_ user: UserDetail, group: FavoriteGroup) async {
        do {
            if let addedFavoriteGroupId {
                let _ = try await FavoriteService.removeFavorite(
                    userData.client,
                    favoriteId: user.id
                ).get()

                if !isAddedFavorite {
                    let _ = try await FavoriteService.addFavorite(
                        userData.client,
                        type: .friend,
                        favoriteId: user.id,
                        tag: group.name
                    ).get()
                    favoriteViewModel.addFriendInFavorite(
                        friend: user,
                        groupId: group.id
                    )
                }

                favoriteViewModel.removeFriendFromFavorite(
                    friendId: user.id,
                    groupId: addedFavoriteGroupId
                )
            } else {
                let _ = try await FavoriteService.addFavorite(
                    userData.client,
                    type: .friend,
                    favoriteId: user.id,
                    tag: group.name
                ).get()
                favoriteViewModel.addFriendInFavorite(friend: user, groupId: group.id)
            }
        } catch {
            print(error)
        }
    }

    func saveNote(_ user: UserDetail) async {
        do {
            let _ = try await UserNoteService.updateUserNote(
                userData.client,
                targetUserId: user.id,
                note: user.note
            )
        } catch {
            print(error)
        }
    }
}
