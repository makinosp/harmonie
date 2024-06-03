//
//  View+frame.swift
//  harmonie
//
//  Created by makinosp on 2024/03/09.
//

import SwiftUI

extension View {
    public func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        self.modifier(SizeViewModifier(size: size, alignment: alignment))
    }
}
