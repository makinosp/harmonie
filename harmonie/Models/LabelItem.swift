//
//  LabelItem.swift
//  Harmonie
//
//  Created by makinosp on 2024/11/16.
//

import MemberwiseInit
import SwiftUICore

@MemberwiseInit
struct LabelItem {
    @Init let value: String
    @Init let caption: String
    @Init let systemName: String
    @Init(default: Font.body) let fontSize: Font
}

extension LabelItem: Identifiable {
    var id: UUID { UUID() }
}
