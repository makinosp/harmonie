//
//  WorldServiceRepresentable.swift
//  Harmonie
//
//  Created by xili on 2024/09/13.
//

import VRCKit

@MainActor
protocol WorldServiceRepresentable {
    var appVM: AppViewModel { get }
}

extension WorldServiceRepresentable {
    var worldService: WorldServiceProtocol {
        appVM.isPreviewMode
        ? WorldPreviewService(client: appVM.client)
        : WorldService(client: appVM.client)
    }
}
