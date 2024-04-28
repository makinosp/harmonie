//
//  UserData.swift
//  friendplus
//
//  Created by makinosp on 2024/03/09.
//

import SwiftUI
import VRCKit

class UserData: ObservableObject {
    @Published var client = APIClient()
    @Published var user: User?
    @Published var favoriteGroups: [FavoriteGroup]?
}
