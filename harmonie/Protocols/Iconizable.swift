//
//  Iconizable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

import SwiftUI

protocol Iconizable {
    var systemName: String { get }
    init(_ systemName: String)
}

extension Iconizable {
    var icon: some View {
        Image(systemName: systemName)
    }
}
