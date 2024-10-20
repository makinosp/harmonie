//
//  Binding+containsBinding.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/20.
//

import SwiftUICore

extension Binding where Value: SetAlgebra & Sendable, Value.Element: Sendable {
    func containsBinding(for value: Value.Element) -> Binding<Bool> {
        Binding<Bool>(
            get: { wrappedValue.contains(value) },
            set: { newValue in
                if newValue {
                    wrappedValue.remove(value)
                } else {
                    wrappedValue.insert(value)
                }
            }
        )
    }
}
