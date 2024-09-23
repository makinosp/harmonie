//
//  WorldServicePresentable.swift
//  Harmonie
//
//  Created by xili on 2024/09/13.
//

import VRCKit

@MainActor
protocol WorldServicePresentable {
    var appVM: AppViewModel { get }
}

extension WorldServicePresentable {
    var worldService: WorldServiceProtocol {
        appVM.isPreviewMode
        ? WorldPreviewService(client: appVM.client)
        : WorldService(client: appVM.client)
    }
}
