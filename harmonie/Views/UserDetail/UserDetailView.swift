//
//  UserDetailView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import AsyncSwiftUI
import NukeUI
import VRCKit

struct UserDetailView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @Environment(\.dismiss) private var dismiss
    @State var user: UserDetail
    @State var instance: Instance?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                profileImageContainer
                contentStacks
            }
        }
        .task {
            if user.isVisible {
                await fetchInstance()
            }
        }
    }

    var isOwned: Bool {
        user.id == appVM.user?.id
    }

    func statusColor(_ user: UserDetail) -> Color {
        user.state == .offline ? UserStatus.offline.color : user.status.color
    }

    @ViewBuilder
    var profileImageContainer: some View {
        if let url = user.thumbnailUrl {
            GradientOverlayImageView(
                url: url,
                maxHeight: 250,
                topContent: { topBar },
                bottomContent: { bottomBar }
            )
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    func profileImage(image: Image) -> some View {
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
                    Text(user.displayName)
                } icon: {
                    Image(systemName: Constants.IconName.circleFilled)
                        .foregroundStyle(statusColor(user))
                }
                .font(.headline)
                statusDescription
            }
            Spacer()
            if user.isFriend  {
                favoriteMenu
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .foregroundStyle(Color.white)
    }

    @ViewBuilder
    var statusDescription: some View {
        if isOwned {
            TextField("StatusDescription", text: $user.statusDescription)
                .font(.subheadline)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(UIColor.systemBackground).opacity(0.25))
                )
        } else {
            Text(user.statusDescription)
                .font(.subheadline)
        }
    }

    var favoriteIconName: String {
        favoriteVM.isAdded(friendId: user.id) ? Constants.IconName.favoriteFilled : Constants.IconName.favorite
    }

    var favoriteMenu: some View {
        Menu {
            ForEach(favoriteVM.favoriteFriendGroups) { group in
                favoriteMenuItem(group: group)
            }
        } label: {
            Image(systemName: favoriteIconName)
                .frame(size: CGSize(width: 12, height: 12))
                .padding(12)
                .background {
                    Circle()
                        .foregroundStyle(Material.regularMaterial)
                }
        }
    }

    func favoriteMenuItem(group: FavoriteGroup) -> some View {
        AsyncButton {
            await updateFavorite(friendId: user.id, group: group)
        } label: {
            Label {
                Text(group.displayName)
            } icon: {
                if favoriteVM.isFriendInFavoriteGroup(
                    friendId: user.id,
                    groupId: group.id
                ) {
                    Image(systemName: Constants.IconName.check)
                }
            }
        }
    }

    var displayStatusAndName: some View {
        HStack(alignment: .bottom) {
            Label {
                Text(user.displayName)
            } icon: {
                Image(systemName: Constants.IconName.circleFilled)
                    .foregroundStyle(user.status.color)
            }
            .font(.headline)
            Text(user.statusDescription)
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
        SectionView {
            Text("Location")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            Text(instance.world.name)
                .font(.body)
        }
    }

    var noteSection: some View {
        SectionView {
            Text("Note")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            TextField("Enter note", text: $user.note, axis: .vertical)
                .font(.body)
        }
    }

    func bioSection(_ bio: String) -> some View {
        SectionView {
            Text("Bio")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            Text(bio)
                .font(.body)
        }
    }

    func bioLinksSection(_ urls: [URL]) -> some View {
        SectionView {
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

    func fetchInstance() async {
        let service = appVM.isDemoMode ? InstancePreviewService(client: appVM.client) : InstanceService(client: appVM.client)
        do {
            instance = try await service.fetchInstance(location: user.location)
        } catch {
            appVM.handleError(error)
        }
    }

    func updateFavorite(friendId: String, group: FavoriteGroup) async {
        do {
            try await favoriteVM.updateFavorite(
                friendId: friendId,
                targetGroup: group
            )
        } catch {
            appVM.handleError(error)
        }
    }

    func saveNote() async {
        let service = appVM.isDemoMode ? UserNotePreviewService(client: appVM.client) : UserNoteService(client: appVM.client)
        do {
            _ = try await service.updateUserNote(
                targetUserId: user.id,
                note: user.note
            )
        } catch {
            appVM.handleError(error)
        }
    }
}
