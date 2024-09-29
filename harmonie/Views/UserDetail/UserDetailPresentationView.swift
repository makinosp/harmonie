//
//  UserDetailPresentationView.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/28.
//

import SwiftUI
import VRCKit

struct UserDetailPresentationView: View, UserServicePresentable {
    @Environment(AppViewModel.self) var appVM
    @State var userDetail: UserDetail?
    private let id: String

    init(id: String) {
        self.id = id
    }

    init(selected: Selected) {
        id = selected.id
    }

    var body: some View {
        if let userDetail = userDetail {
            UserDetailView(user: userDetail)
                .refreshable {
                    await fetchUser(id: id)
                }
        } else {
            ProgressScreen()
                .task(id: id) {
                    await fetchUser(id: id)
                }
                .navigationTitle("Loading...")
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func fetchUser(id: String) async {
        do {
            userDetail = try await userService.fetchUser(userId: id)
        } catch {
            appVM.handleError(error)
        }
    }
}
