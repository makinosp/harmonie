//
//  UserData.swift
//  harmonie
//
//  Created by makinosp on 2024/03/09.
//

import Foundation
import VRCKit

@MainActor
class UserData: ObservableObject {
    @Published var user: User?
    @Published var step: Step = .initializing
    var client = APIClient()

    @Published var onlineFriends: [Friend] = []
    @Published var offlineFriends: [Friend] = []

    public enum Step: Equatable {
        case initializing
        case loggingIn
        case loggedIn
        case done
    }

    init() {
        client.updateCookies()
    }

    func logout() {
        user = nil
        client.deleteCookies()
        client = APIClient()
        step = .loggedIn
    }

    /// Fetch friends from API
    func fetchAllFriends() async throws {
        guard let user = user else { return }
        onlineFriends = try await FriendService.fetchFriends(
            client,
            count: user.onlineFriends.count,
            offline: false
        )
    }
}
