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
    private let outerSize: CGSize

    init(_ content: S, outerSize: CGSize, isCutedOut: Bool = false) {
        self.content = content
        self.outerSize = outerSize
        self.isCutedOut = isCutedOut
    }

    private var frameSize: CGSize {
        outerSize * 0.3
    }

    private var cutoutSize: CGSize {
        outerSize * 0.15
    }

    private var offset: CGSize {
        outerSize * 0.36
    }

    var body: some View {
        Circle()
            .fill(content)
            .frame(size: frameSize)
            .overlay {
                Circle()
                    .blendMode(.destinationOut)
                    .frame(size: cutoutSize)
            }
            .compositingGroup()
            .offset(x: offset.width, y: offset.height)
    }
}

#Preview {
    StatusIndicator(
        .blue,
        outerSize: CGSize(width: 120, height: 120)
    )
}
