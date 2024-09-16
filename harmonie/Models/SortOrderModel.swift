//
//  SortOrderModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/16.
//

enum SortOrder {
    case asc, desc

    mutating func toggle() {
        switch self {
        case .asc:
            self = .desc
        case .desc:
            self = .asc
        }
    }
}
