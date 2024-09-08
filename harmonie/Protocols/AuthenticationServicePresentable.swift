//
//  AuthenticationServicePresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/08.
//

import VRCKit

protocol AuthenticationServicePresentable {
    var appVM: AppViewModel { get }
}

extension AuthenticationServicePresentable {
    @MainActor
    var authenticationService: AuthenticationServiceProtocol {
        appVM.isDemoMode
        ? AuthenticationPreviewService(client: appVM.client)
        : AuthenticationService(client: appVM.client)
    }
}
