//
//  InstanceServiceRepresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/09.
//

import VRCKit

@MainActor
protocol InstanceServiceRepresentable {
    var appVM: AppViewModel { get }
}

extension InstanceServiceRepresentable {
    var instanceService: InstanceServiceProtocol {
        appVM.isPreviewMode
        ? InstancePreviewService(client: appVM.client)
        : InstanceService(client: appVM.client)
    }
}
