//
//  LabelItem.swift
//  Harmonie
//
//  Created by makinosp on 2024/11/16.
//

import Foundation

struct LabelItem<T> {
    let value: T
    let caption: String
    let icon: IconSet
}

extension LabelItem where T == CustomStringConvertible {
    var text: String { value.description }
}

extension LabelItem where T == Optional<Int> {
    var unwrappedValue: Int { value ?? .zero }
    var text: String { unwrappedValue.description }
}

extension LabelItem where T == Optional<Date> {
    var text: String {
        value?.formatted(date: .numeric, time: .omitted) ?? "Unknown"
    }
}
