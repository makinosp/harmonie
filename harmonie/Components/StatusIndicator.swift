//
//  StatusIndicator.swift
//  Harmonie
//
//  Created by xili on 2024/09/19.
//

import SwiftUI

struct StatusIndicator<S>: View where S: ShapeStyle {
    private let content: S
    private let isCutedOut: Bool
    private let outer: CGFloat

    init(_ content: S, outer: CGFloat, isCutedOut: Bool = false) {
        self.content = content
        self.outer = outer
        self.isCutedOut = isCutedOut
    }

    private var frameSize: CGFloat {
        outer * 0.3
    }

    private var cutoutSize: CGFloat {
        outer * 0.15
    }

    private var offset: CGFloat {
        outer * 0.36
    }

    var body: some View {
        Circle()
            .fill(content)
            .frame(width: frameSize, height: frameSize)
            .overlay {
                Circle()
                    .blendMode(.destinationOut)
                    .frame(
                        width: isCutedOut ? cutoutSize : .zero,
                        height: isCutedOut ? cutoutSize : .zero
                    )
            }
            .compositingGroup()
            .offset(x: offset, y: offset)
    }
}

#Preview {
    StatusIndicator(.blue, outer: 120)
}
