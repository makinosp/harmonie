//
//  SwipeActions.swift
//  Harmonie
//
//  Created by makinosp on 2025/03/23.
//

enum SwipeActionType: String, CaseIterable {
    case favorite
    case delete
}

extension SwipeActionType: Identifiable {
    var id: String { rawValue }
}

struct SwipeActions {
    var leading: [SwipeActionType] = [.favorite]
    var trailing: [SwipeActionType] = [.delete]
}
