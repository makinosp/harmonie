//
//  View+ErrorAlertModifier.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/28.
//

import SwiftUI

extension View {
    func errorAlert(_ action: @escaping () -> Void = {}) -> some View {
        modifier(ErrorAlertModifier(action))
    }
}

private struct ErrorAlertModifier: ViewModifier {
    @EnvironmentObject var userData: AppViewModel
    let action: () -> Void

    init(_ action: @escaping () -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .alert(
                isPresented: $userData.isPresentedAlert,
                error: userData.vrckError
            ) { _ in
                Button("OK", action: action)
            } message: { error in
                Text(error.failureReason ?? "Try again later.")
            }
    }
}
