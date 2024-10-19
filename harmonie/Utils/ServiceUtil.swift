//
//  ServiceUtil.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/19.
//

import VRCKit

actor APIServiceUtil: Sendable {
    let authenticationService: AuthenticationServiceProtocol
    let instanceService: InstanceServiceProtocol
    let userNoteService: UserNoteServiceProtocol
    let userService: UserServiceProtocol
    let worldService: WorldServiceProtocol

    init(isPreviewMode: Bool, client: APIClient) {
        if isPreviewMode {
            authenticationService = AuthenticationPreviewService(client: client)
            instanceService = InstancePreviewService(client: client)
            userNoteService = UserNotePreviewService(client: client)
            userService = UserPreviewService(client: client)
            worldService = WorldPreviewService(client: client)
        } else {
            authenticationService = AuthenticationService(client: client)
            instanceService = InstanceService(client: client)
            userNoteService = UserNoteService(client: client)
            userService = UserService(client: client)
            worldService = WorldService(client: client)
        }
    }
}
