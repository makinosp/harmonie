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
    @State var editingUserInfo: EditableUserInfo
    @State var note: String
    private let initialValue: EditableUserInfo
    private let initialNoteValue: String

    init(user: UserDetail) {
        _user = State(initialValue: user)
        initialValue = EditableUserInfo(detail: user)
        _editingUserInfo = State(initialValue: initialValue)
        initialNoteValue = user.note
        _note = State(initialValue: initialNoteValue)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                profileImageContainer
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

    var hasAnyDiff: Bool {
        editingUserInfo != initialValue ||
        note != initialNoteValue
    }

    var isOwned: Bool {
        user.id == appVM.user?.id
    }

    var statusColor: Color {
        user.state == .offline ? UserStatus.offline.color : user.status.color
    }

    @ViewBuilder var profileImageContainer: some View {
        if let url = user.thumbnailUrl {
            GradientOverlayImageView(
                url: url,
                maxHeight: 250,
                topContent: { topBar },
                bottomContent: { bottomBar }
            )
        }
    }

    var topBar: some View {
        HStack {
            Spacer()
            if hasAnyDiff {
                saveButton
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

    var saveButton: some View {
        AsyncButton("Save") {
            if editingUserInfo != initialValue {
                await saveUserInfo()
            }
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
                    Image(systemName: Constants.IconName.circleFilled)
                        .foregroundStyle(statusColor)
                }
                .font(.headline)
                statusDescription
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .foregroundStyle(Color.white)
    }

    @ViewBuilder var statusDescription: some View {
        if isOwned {
            TextField("StatusDescription", text: $editingUserInfo.statusDescription)
                .font(.subheadline)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(uiColor: .systemBackground).opacity(0.25))
                )
        } else {
            Text(user.statusDescription)
                .lineLimit(1)
                .font(.subheadline)
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
