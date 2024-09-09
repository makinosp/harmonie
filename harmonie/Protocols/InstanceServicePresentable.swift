//
//  InstanceServicePresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/09.
//

import VRCKit

protocol InstanceServicePresentable {
    var appVM: AppViewModel { get }
}

extension InstanceServicePresentable {
    @MainActor
    var instanceService: InstanceServiceProtocol {
        appVM.isDemoMode
        ? InstancePreviewService(client: appVM.client)
        : InstanceService(client: appVM.client)
    }
}
