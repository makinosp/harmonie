//
//  FriendViewModel+SortConditions.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/15.
//

extension FriendViewModel {
    enum SortType: String, Hashable, Identifiable, CaseIterable {
        case latest, oldest, name, loginLatest, loginOldest, status
        var id: String { rawValue }
    }
}

extension FriendViewModel.SortType: CustomStringConvertible {
    var description: String {
        switch self {
        case .latest:
            String(localized: "Latest")
        case .oldest:
            String(localized: "Oldest")
        case .name:
            String(localized: "Name")
        case .loginLatest:
            String(localized: "Login latest")
        case .loginOldest:
            String(localized: "Login oldest")
        case .status:
            String(localized: "Status")
        }
    }
}
