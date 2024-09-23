//
//  InstanceServicePresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/09.
//

import VRCKit

@MainActor
protocol InstanceServicePresentable {
    var appVM: AppViewModel { get }
}

extension InstanceServicePresentable {
    var instanceService: InstanceServiceProtocol {
        appVM.isPreviewMode
        ? InstancePreviewService(client: appVM.client)
        : InstanceService(client: appVM.client)
    }
}
