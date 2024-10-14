//
//  View+SizeModifier.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/09.
//

import SwiftUI

extension View {
    func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        modifier(SizeModifier(size: size, alignment: alignment))
    }
}

private struct SizeModifier: ViewModifier {
    let size: CGSize
    let alignment: Alignment

    func body(content: Content) -> some View {
        content
            .frame(width: size.width, height: size.height, alignment: alignment)
    }
}
