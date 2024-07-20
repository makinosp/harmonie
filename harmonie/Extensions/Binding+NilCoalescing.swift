//
//  Binding+NilCoalescing.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/17.
//

import SwiftUI

extension Binding {
    static func ?? <T>(optional: Self, defaultValue: T) -> Binding<T> where Value == T? {
        .init(
            get: { optional.wrappedValue ?? defaultValue },
            set: { optional.wrappedValue = $0 }
        )
    }
}
