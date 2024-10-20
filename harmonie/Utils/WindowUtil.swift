//
//  WindowUtil.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/15.
//

import UIKit

enum WindowUtil {
    @MainActor static var window: UIWindowScene? {
        UIApplication.shared.connectedScenes.first as? UIWindowScene
    }

    @MainActor static var bounds: CGRect {
        window?.screen.bounds ?? .zero
    }

    @MainActor static var height: CGFloat {
        window?.screen.bounds.height ?? .zero
    }

    @MainActor static var width: CGFloat {
        window?.screen.bounds.width ?? .zero
    }
}
