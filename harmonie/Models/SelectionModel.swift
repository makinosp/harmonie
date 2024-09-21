//
//  SelectionModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/28.
//

struct Selected: Hashable, Identifiable, Sendable {
    let id: String
}

struct SegmentIdSelection: Hashable, Sendable {
    let selected: Selected
    let segment: Segment
}

extension SegmentIdSelection: Identifiable {
    var id: Int { hashValue }
}

extension SegmentIdSelection {
    init(friendId: String) {
        selected = Selected(id: friendId)
        segment = .friend
    }
}

extension SegmentIdSelection {
    init(worldId: String) {
        selected = Selected(id: worldId)
        segment = .world
    }
}
