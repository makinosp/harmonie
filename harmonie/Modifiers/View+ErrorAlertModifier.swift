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
    @Environment(AppViewModel.self) var appVM: AppViewModel
    private let action: () -> Void

    init(_ action: @escaping () -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        @Bindable var appVM = appVM
        content
            .alert(
                isPresented: $appVM.isPresentedAlert,
                error: appVM.vrckError
            ) { _ in
                Button("OK") {
                    action()
                    appVM.vrckError = nil
                }
            } message: { error in
                Text(error.failureReason ?? "Try again later.")
            }
    }
}
