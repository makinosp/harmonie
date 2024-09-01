//
//  InstanceLocation.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/01.
//

import VRCKit

struct InstanceLocation: Hashable, Identifiable {
    var location: FriendsLocation
    var instance: Instance
    var id: Int { hashValue }
}
