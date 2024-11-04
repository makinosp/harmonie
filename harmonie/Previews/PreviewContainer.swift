//
//  PreviewContainer.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/26.
//

import SwiftUI
import VRCKit

@MainActor
struct PreviewContainer<Content> {
    private let content: Content
    private let appVM: AppViewModel
    private let friendVM: FriendViewModel
    private let favoriteVM: FavoriteViewModel
}

extension PreviewContainer: View where Content: View {
    var body: some View {
        content
            .environment(appVM)
            .environment(friendVM)
            .environment(favoriteVM)
            .task {
                do {
                    try await friendVM.fetchAllFriends()
                    try await favoriteVM.fetchFavoriteFriends(
                        service: FavoritePreviewService(client: appVM.client),
                        friendVM: friendVM
                    )
                } catch {
                    appVM.handleError(error)
                }
            }
    }
}

extension PreviewContainer where Content: View {
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        appVM = AppViewModel(isPreviewMode: true)
        friendVM = FriendViewModel(appVM: appVM)
        favoriteVM = FavoriteViewModel()
    }

    init(@ViewBuilder content: (_ user: UserDetail) -> Content) {
        let userDetail = PreviewData.userDetail(
            id: UUID(),
            location: .private,
            state: .active,
            status: .active
        )
        self.init { content(userDetail) }
    }
}
