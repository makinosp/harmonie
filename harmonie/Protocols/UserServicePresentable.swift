//
//  UserServicePresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/09.
//

import VRCKit

@MainActor
protocol UserServicePresentable {
    var appVM: AppViewModel { get }
}

extension UserServicePresentable {
    var userService: UserServiceProtocol {
        appVM.isPreviewMode
        ? UserPreviewService(client: appVM.client)
        : UserService(client: appVM.client)
    }
}
