//
//  BittenView.swift
//  Harmonie
//
//  Created by xili on 2024/09/18.
//

import SwiftUI

struct BittenView<Content>: View where Content: View {
    @State private var size: CGSize?
    private let content: Content
    private let ratio: CGFloat

    init(ratio: CGFloat = 0.4, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.ratio = ratio
    }

    private var transformed: CGSize {
        guard let size = size else { return .zero }
        return CGSize(width: size.width * ratio, height: size.height * ratio)
    }

    var body: some View {
        content
            .mask(
                BittenCircleMask(biteSize: transformed)
                    .fill(style: FillStyle(eoFill: true))
            )
            .background {
                GeometryReader { geometry in
                    Color.clear.onAppear {
                        size = geometry.size
                    }
                }
            }
    }
}

#Preview {
    BittenView {
        Circle()
            .fill(.blue)
            .frame(width: 120, height: 120)
    }
}
