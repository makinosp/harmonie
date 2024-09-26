//
//  PreviewContainer.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/26.
//

import SwiftUI
import VRCKit

@MainActor
struct PreviewContainer<Content> where Content: View {
    private let content: Content
    private let appVM: AppViewModel
    private let friendVM: FriendViewModel
    private let favoriteVM: FavoriteViewModel
}

extension PreviewContainer: View {
    var body: some View {
        content
            .environment(appVM)
            .environment(friendVM)
            .environment(favoriteVM)
            .task {
                do {
                    try await friendVM.fetchAllFriends(
                        service: FriendPreviewService(client: appVM.client)
                    )
                    try await favoriteVM.fetchFavorite(
                        service: FavoritePreviewService(client: appVM.client),
                        friendVM: friendVM
                    )
                } catch {
                    appVM.handleError(error)
                }
            }
    }
}

extension PreviewContainer {
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        appVM = AppViewModel(isPreviewMode: true)
        friendVM = FriendViewModel(user: PreviewDataProvider.shared.previewUser)
        favoriteVM = FavoriteViewModel()
    }
}
