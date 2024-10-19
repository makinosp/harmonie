//
//  FilterUserStatus.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/19.
//

import VRCKit

enum FilterUserStatus: Hashable {
    case all, status(UserStatus)
}

extension FilterUserStatus: Identifiable {
    var id: Int { hashValue }
}

extension FilterUserStatus: CustomStringConvertible {
    var description: String {
        switch self {
        case .all: "All"
        case .status(let status):
            status.description
        }
    }
}

extension FilterUserStatus: CaseIterable {
    static var allCases: [Self] {
        [
            .all,
            .status(.active),
            .status(.joinMe),
            .status(.askMe),
            .status(.busy),
            .status(.offline)
        ]
    }
}
