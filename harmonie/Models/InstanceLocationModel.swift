//
//  InstanceLocationModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/01.
//

import VRCKit

struct InstanceLocation: Hashable {
    var location: FriendsLocation
    var instance: Instance
}

extension InstanceLocation: Identifiable {
    var id: Int { hashValue }
}
