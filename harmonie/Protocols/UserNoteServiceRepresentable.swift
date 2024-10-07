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
        ? UserNoteService(client: appVM.client)
        : UserNotePreviewService(client: appVM.client)
    }
}
