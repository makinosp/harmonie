//
//  FriendViewModel+SortType.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/16.
//

extension FriendViewModel {
    enum SortType: String, Hashable, Identifiable, CaseIterable {
        case `default`, displayName, lastLogin, status
        var id: Int { hashValue }
    }
}

extension FriendViewModel.SortType: CustomStringConvertible {
    var description: String {
        switch self {
        case .displayName: "Name"
        case .lastLogin: "Last Login"
        default: rawValue.localizedCapitalized
        }
    }
}
