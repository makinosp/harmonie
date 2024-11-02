//
//  PreviewString.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/20.
//

enum PreviewString {
    enum Name: String, CaseIterable {
        case emma
        case josh
        case clarke
        case nathalie
    }
}

extension PreviewString.Name {
    static var randomValue: String {
        allCases.randomElement()?.rawValue.capitalized ?? ""
    }
}
