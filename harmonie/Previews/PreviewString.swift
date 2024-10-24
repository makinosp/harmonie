//
//  PreviewString.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/20.
//

enum PreviewString {
    enum name: String, CaseIterable {
        case emma
        case josh
        case clarke
    }
}

extension PreviewString.name {
    static var randomValue: String {
        allCases.randomElement()?.rawValue.capitalized ?? ""
    }
}
