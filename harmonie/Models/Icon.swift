//
//  Icon.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

import SwiftUI

struct Icon: Iconizable, Hashable {
    let systemName: String
    let scale: Image.Scale

    init(_ systemName: String, scale: Image.Scale = .medium) {
        self.systemName = systemName
        self.scale = scale
    }
}
