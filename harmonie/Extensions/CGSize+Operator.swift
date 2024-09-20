//
//  CGSize+Operator.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/20.
//

import CoreGraphics

extension CGSize {
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}
