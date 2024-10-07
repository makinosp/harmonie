//
//  InstanceLocationModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/01.
//

import VRCKit

struct InstanceLocation: Hashable {
    let location: FriendsLocation
    let instance: Instance
}

extension InstanceLocation: Identifiable {
    var id: Int { hashValue }
}
