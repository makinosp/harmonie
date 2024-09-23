//
//  AuthenticationServicePresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/08.
//

import VRCKit

@MainActor
protocol AuthenticationServicePresentable {
    var appVM: AppViewModel { get }
}

extension AuthenticationServicePresentable {
    var authenticationService: AuthenticationServiceProtocol {
        appVM.isPreviewMode
        ? AuthenticationPreviewService(client: appVM.client)
        : AuthenticationService(client: appVM.client)
    }
}
