//
//  Icon.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

struct Icon: Iconizable, Hashable {
    let systemName: String

    init(_ systemName: String) {
        self.systemName = systemName
    }
}
