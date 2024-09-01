//
//  AuthenticationView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/08.
//

import AsyncSwiftUI
import VRCKit

struct AuthenticationView: View {
    @AppStorage(Constants.Keys.isSavedOnKeyChain) var isSavedOnKeyChain = false
    @AppStorage(Constants.Keys.username) var username: String = ""
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @State var verifyType: VerifyType?
    @State var password: String = ""
    @State var code: String = ""
    @State private var isRequesting = false
    @State var isPresentedPopover = false

    var body: some View {
        NavigationStack {
            loginView
                .navigationDestination(item: $verifyType) { _ in
                    otpView
                }
        }
    }

    @ViewBuilder
    func loginButton(_ text: String, action: @escaping () async -> Void) -> some View {
        AsyncButton {
            defer { isRequesting = false }
            isRequesting = true
            await action()
        } label: {
            if isRequesting {
                ProgressView()
            } else {
                Text(text)
            }
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .disabled(isRequesting)
    }
}

#Preview {
    AuthenticationView()
        .environment(AppViewModel())
}
