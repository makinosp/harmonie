//
//  UserDetailPresentationView.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/28.
//

import SwiftUI
import VRCKit

struct UserDetailPresentationView: View {
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
        let service = appVM.isDemoMode
        ? UserPreviewService(client: appVM.client)
        : UserService(client: appVM.client)
        do {
            userDetail = try await service.fetchUser(userId: id)
        } catch {
            appVM.handleError(error)
        }
    }
}
