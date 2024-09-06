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
    @FocusState var isFocusedNoteField
    @State var user: UserDetail
    @State var instance: Instance?
    @State var note: String
    @State var isRequesting = false

    init(user: UserDetail) {
        _user = State(initialValue: user)
        _note = State(initialValue: user.note)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let url = user.imageUrl(.origin) {
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
        .onAppear {
            print(user.userIcon ?? "")
        }
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
            languageSection
            let urls = user.bioLinks.elements
            if !urls.isEmpty {
                bioLinksSection(urls)
            }
            activitySection
        }
        .padding()
    }
}
