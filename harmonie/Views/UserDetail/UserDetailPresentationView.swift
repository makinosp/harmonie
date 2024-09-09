//
//  UserDetailPresentationView.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/28.
//

import SwiftUI
import VRCKit

struct UserDetailPresentationView: View, UserServicePresentable {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @State var userDetail: UserDetail?
    let id: String

    var body: some View {
        if let userDetail = userDetail {
            UserDetailView(user: userDetail)
                .refreshable {
                    await fetchUser(id: id)
                }
        } else {
            ProgressView()
                .task(id: id) {
                    await fetchUser(id: id)
                }
        }
    }

    func fetchUser(id: String) async {
        do {
            userDetail = try await userService.fetchUser(userId: id)
        } catch {
            appVM.handleError(error)
        }
    }
}
