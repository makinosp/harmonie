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

@MainActor @MemberwiseInit
private struct ErrorAlertModifier {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Init(.internal, escaping: true, label: "_") private let action: () -> Void

    typealias ErrorKeyPath<E> = ReferenceWritableKeyPath<AppViewModel, E?>

    func isThrownError<E>(_ errorKeyPath: ErrorKeyPath<E>) -> Binding<Bool> where E: Error {
        Binding<Bool>(
            get: { appVM[keyPath: errorKeyPath] != nil },
            set: { isErrorActive in
                guard !isErrorActive else { return }
                appVM[keyPath: errorKeyPath] = nil
            }
        )
    }
}

extension ErrorAlertModifier: ViewModifier {
    func body(content: Content) -> some View {
        @Bindable var appVM = appVM
        content
            .alert(
                isPresented: isThrownError(\.vrckError),
                error: appVM.vrckError
            ) { _ in
                Button("OK") {
                    action()
                }
            } message: { error in
                Text(error.failureReason ?? "Try again later.")
            }
            .alert(
                isPresented: isThrownError(\.applicationError),
                error: appVM.applicationError
            ) { _ in
                Button("OK") {
                    action()
                }
            } message: { error in
                Text(error.failureReason ?? "Try again later.")
            }
    }
}
