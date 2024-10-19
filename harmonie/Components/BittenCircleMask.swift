//
//  BittenCircleMask.swift
//  Harmonie
//
//  Created by xili on 2024/09/18.
//

import MemberwiseInit
import SwiftUI

@MemberwiseInit
struct BittenCircleMask {
    @Init(.internal) private let biteSize: CGSize
    @Init(.internal, default: 0.65) private let offsetRatio: CGFloat
}

extension BittenCircleMask: Shape {
    func path(in rect: CGRect) -> Path {
        var path = rectanglePath(rect)
        path.addPath(circlePath(rect))
        return path
    }

    private func rectanglePath(_ rect: CGRect) -> Path {
        Rectangle().path(in: rect)
    }

    private func circlePath(_ rect: CGRect) -> Path {
        Circle()
            .path(in: circleRect(rect, size: biteSize))
    }

    private func circleRect(_ rect: CGRect, size: CGSize) -> CGRect {
        CGRect(origin: .zero, size: size)
            .offsetBy(dx: offsetBy(rect.maxX), dy: offsetBy(rect.maxX))
    }

    private func offsetBy(_ maxX: CGFloat) -> CGFloat {
        maxX * offsetRatio
    }
}
