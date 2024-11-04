//
//  GeometryProxy+Equatable.swift
//  Harmonie
//
//  Created by makinosp on 2024/11/04.
//

import SwiftUICore

extension GeometryProxy: @retroactive Equatable {
    public static func == (lhs: GeometryProxy, rhs: GeometryProxy) -> Bool {
        lhs.size == rhs.size && lhs.safeAreaInsets == rhs.safeAreaInsets
    }
}
