//
//  WindowUtil.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/15.
//

import UIKit

@MainActor enum WindowUtil {
    static var window: UIWindowScene? {
        UIApplication.shared.connectedScenes.first as? UIWindowScene
    }

    static var bounds: CGRect {
        window?.screen.bounds ?? .zero
    }

    static var height: CGFloat {
        window?.screen.bounds.height ?? .zero
    }

    static var width: CGFloat {
        window?.screen.bounds.width ?? .zero
    }
}
