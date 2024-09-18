//
//  Status+isWebColor.swift
//  Harmonie
//
//  Created by xili on 2024/09/17.
//

import SwiftUI
import VRCKit

extension UserPlatform {
    var isWebColor: Color {
        switch self {
        case .web: Color.black.opacity(0.7)
        case .standalonewindows: .clear
        default: Color.black.opacity(0.7)
        }
    }
}
