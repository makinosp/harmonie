//
//  View+ErrorAlertModifier.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/28.
//

import MemberwiseInit
import SwiftUI

extension View {
    func errorAlert(_ action: @escaping () -> Void = {}) -> some View {
        modifier(ErrorAlertModifier(action))
    }
}

@MemberwiseInit
private struct ErrorAlertModifier {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Init(.internal, escaping: true, label: "_") private let action: () -> Void
}

extension ErrorAlertModifier: ViewModifier {
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
