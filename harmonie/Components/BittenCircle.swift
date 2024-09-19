//
//  BittenCircle.swift
//  Harmonie
//
//  Created by xili on 2024/09/18.
//

import SwiftUI

struct BittenCircle: Shape {
    private let biteSize: CGFloat =  Constants.IconSize.thumbnailOutside.width * 0.4
    private let offsetRatio: CGFloat = 0.65
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
    private func circleRect(_ rect: CGRect, size: CGFloat) -> CGRect {
        CGRect(origin: .zero, size: CGSize(width: size, height: size))
            .offsetBy(dx: offsetBy(rect.maxX), dy: offsetBy(rect.maxX))
    }
    private func offsetBy(_ maxX: CGFloat) -> CGFloat {
        maxX * offsetRatio
    }
}

struct BittenCircle_Previews: PreviewProvider {
    static var previews: some View {
        Circle()
            .foregroundStyle(.blue)
            .mask(
                BittenCircle()
                    .fill(style: FillStyle(eoFill: true))
            )
            .frame(width: Constants.IconSize.thumbnailOutside.width, height: Constants.IconSize.thumbnailOutside.height)
    }
}
