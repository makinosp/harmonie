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
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(\.dismiss) private var dismiss
    @State var user: UserDetail
    @State var instance: Instance?
    @State var note: String
    let initialValue: EditableUserInfo
    let initialNoteValue: String

    init(user: UserDetail) {
        _user = State(initialValue: user)
        initialNoteValue = user.note
        _note = State(initialValue: initialNoteValue)
        initialValue = EditableUserInfo(detail: user)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let url = user.thumbnailUrl {
                    profileImageContainer(url: url)
                }
                contentStacks
            }
        }
        .navigationTitle(user.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbar }
        .task {
            if user.isVisible {
                await fetchInstance()
            }
        }
    }

    var statusColor: Color {
        user.state == .offline ? UserStatus.offline.color : user.status.color
    }

    func profileImageContainer(url: URL) -> some View {
        GradientOverlayImageView(
            url: url,
            maxHeight: 250,
            bottomContent: { bottomBar }
        )
    }

    var saveButton: some View {
        AsyncButton("Save") {
            if note != initialNoteValue {
                await saveNote()
            }
        }
        .foregroundStyle(Color.accentColor)
        .buttonStyle(.borderedProminent)
        .tint(Material.regularMaterial)
        .buttonBorderShape(.capsule)
    }

    var bottomBar: some View {
        HStack {
            HStack(alignment: .bottom) {
                Label {
                    Text(user.displayName)
                } icon: {
                    Constants.Icon.circleFilled
                        .foregroundStyle(statusColor)
                }
                .font(.headline)
                statusDescription
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

    var statusDescription: some View {
        Text(user.statusDescription)
            .lineLimit(1)
            .font(.subheadline)
    }

    var displayStatusAndName: some View {
        HStack(alignment: .bottom) {
            Label {
                Text(user.displayName)
            } icon: {
                Constants.Icon.circleFilled
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
            let urls = user.bioLinks.elements
            if !urls.isEmpty {
                bioLinksSection(urls)
            }
            activitySection
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
            TextField("Enter note", text: $note, axis: .vertical)
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
}
