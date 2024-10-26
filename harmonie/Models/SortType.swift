//
//  SortType.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/19.
//

enum SortType: String, Hashable, CaseIterable {
    case latest, oldest, name, loginLatest, loginOldest, status
}

extension SortType: Identifiable {
    var id: String { rawValue }
}

extension SortType: CustomStringConvertible {
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

extension SortType {
    var icon: Iconizable {
        switch self {
        case .latest, .oldest: IconSet.stopwatch
        case .name: IconSet.at
        case .loginLatest, .loginOldest: IconSet.calendar
        case .status: IconSet.circleFilled
        }
    }
}
