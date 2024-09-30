//
//  Iconizable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

import SwiftUI

protocol Iconizable {
    var systemName: String { get }
    var scale: Image.Scale { get }
}

extension Iconizable {
    var icon: some View {
        Image(systemName: systemName)
            .imageScale(scale)
    }
}
