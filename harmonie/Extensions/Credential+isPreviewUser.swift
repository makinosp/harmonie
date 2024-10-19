//
//  Credential+isPreviewUser.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/19.
//

import VRCKit

extension Credential {
    static private let previewUser = "demonstration"
    var isPreviewUser: Bool {
        username == Credential.previewUser && password == Credential.previewUser
    }
}
