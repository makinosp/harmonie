//
//  UserDetailView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import AsyncSwiftUI
import NukeUI
import VRCKit

extension UserDetailView: FavoriteServiceRepresentable {}
extension UserDetailView: InstanceServiceRepresentable {}

struct UserDetailView: View {
    @Environment(AppViewModel.self) var appVM
    @Environment(FavoriteViewModel.self) var favoriteVM
    @Environment(FriendViewModel.self) var friendVM
    @Environment(\.dismiss) private var dismiss
    @State var user: UserDetail
    @State var instance: Instance?
    @State var isRequesting = false
    @State var isRequestingInMenu = false
    @State var lastActivity = ""
    @State var isPresentedNoteEditor = false

    init(user: UserDetail) {
        self.user = user
    }

    var body: some View {
        ScrollView {
            VStack {
                GradientOverlayImageView(
                    imageUrl: user.imageUrl(.x1024),
                    thumbnailImageUrl: user.imageUrl(.x256),
                    height: 250,
                    topContent: { topOverlay },
                    bottomContent: { bottomOverlay }
                )
                contentStacks
            }
        }
        .navigationTitle(user.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .toolbar { toolbar }
        .task {
            if case let .id(id) = user.location {
                await fetchInstance(id: id)
            }
        }
        .task {
            lastActivity = await DateUtil.shared.formatRelative(from: user.lastActivity)
        }
    }

    private var contentStacks: some View {
        VStack {
            locationSection
            noteSection
            if let bio = user.bio {
                bioSection(bio)
            }
            if !user.tags.languageTags.isEmpty {
                languageSection
            }
            let urls = user.bioLinks.wrappedValue
            if !urls.isEmpty {
                bioLinksSection(urls)
            }
            activitySection
        }
    }
}

#Preview {
    PreviewContainer { userDetail in
        UserDetailView(user: userDetail)
    }
}
