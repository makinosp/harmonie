//
//  FavoriteType+LocalizedStringKey.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/30.
//

import VRCKit
import SwiftUI

extension FavoriteType {
    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .world:
            LocalizedStringKey("World")
        case .avatar:
            LocalizedStringKey("Avatar")
        case .friend:
            LocalizedStringKey("Friend")
        }
    }
}
