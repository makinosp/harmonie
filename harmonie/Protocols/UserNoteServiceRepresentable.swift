//
//  UserNoteServiceRepresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/07.
//

import VRCKit

@MainActor
protocol UserNoteServiceRepresentable {
    var appVM: AppViewModel { get }
}

extension UserNoteServiceRepresentable {
    var userNoteService: UserNoteServiceProtocol {
        appVM.isPreviewMode
        ? UserNotePreviewService(client: appVM.client)
        : UserNoteService(client: appVM.client)
    }
}
