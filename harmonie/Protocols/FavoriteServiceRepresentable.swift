//
//  FavoriteServiceRepresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/08.
//

import VRCKit

@MainActor
protocol FavoriteServiceRepresentable {
    var appVM: AppViewModel { get }
}

extension FavoriteServiceRepresentable {
    var favoriteService: FavoriteServiceProtocol {
        appVM.isPreviewMode
        ? FavoritePreviewService(client: appVM.client)
        : FavoriteService(client: appVM.client)
    }
}
