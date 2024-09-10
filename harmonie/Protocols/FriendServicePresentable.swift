//
//  FriendServicePresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/08.
//

import VRCKit

protocol FriendServicePresentable {
    var appVM: AppViewModel { get }
}

extension FriendServicePresentable {
    @MainActor
    var friendService: FriendServiceProtocol {
        appVM.isPreviewMode
        ? FriendPreviewService(client: appVM.client)
        : FriendService(client: appVM.client)
    }
}
