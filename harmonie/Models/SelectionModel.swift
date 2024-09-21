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
