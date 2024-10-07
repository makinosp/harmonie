//
//  FriendServiceRepresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/08.
//

import VRCKit

@MainActor
protocol FriendServiceRepresentable {
    var appVM: AppViewModel { get }
}

extension FriendServiceRepresentable {
    var friendService: FriendServiceProtocol {
        appVM.isPreviewMode
        ? FriendPreviewService(client: appVM.client)
        : FriendService(client: appVM.client)
    }
}
