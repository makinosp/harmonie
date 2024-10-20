//
//  Binding+NilCoalescing.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/17.
//

import SwiftUICore

extension Binding where Value: Sendable {
    static func ?? <T>(optional: Self, defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(
            get: { optional.wrappedValue ?? defaultValue },
            set: { optional.wrappedValue = $0 }
        )
    }
}
