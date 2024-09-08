//
//  FavoriteServicePresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/08.
//

import VRCKit

protocol FavoriteServicePresentable {
    var appVM: AppViewModel { get }
}

extension FavoriteServicePresentable {
    @MainActor
    var favoriteService: FavoriteServiceProtocol {
        appVM.isDemoMode
        ? FavoritePreviewService(client: appVM.client)
        : FavoriteService(client: appVM.client)
    }
}
