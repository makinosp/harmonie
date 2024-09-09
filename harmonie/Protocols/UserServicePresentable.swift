//
//  UserServicePresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/09.
//

import VRCKit

protocol UserServicePresentable {
    var appVM: AppViewModel { get }
}

extension UserServicePresentable {
    @MainActor
    var userService: UserServiceProtocol {
        appVM.isDemoMode
        ? UserPreviewService(client: appVM.client)
        : UserService(client: appVM.client)
    }
}
