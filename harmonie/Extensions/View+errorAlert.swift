//
//  View+errorAlert.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/28.
//

import SwiftUI

extension View {
    func errorAlert(_ action: @escaping () -> Void = {}) -> some View {
        modifier(ErrorAlertViewModifier(action))
    }
}
