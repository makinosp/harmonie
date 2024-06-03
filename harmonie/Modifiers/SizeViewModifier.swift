//
//  SizeViewModifier.swift
//  harmonie
//
//  Created by makinosp on 2024/03/09.
//

import SwiftUI

struct SizeViewModifier: ViewModifier {
    let size: CGSize
    let alignment: Alignment

    func body(content: Content) -> some View {
        content
            .frame(width: size.width, height: size.height, alignment: alignment)
    }
}
