//
//  AuthenticationView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/08.
//

import AsyncSwiftUI
import VRCKit

struct AuthenticationView: View {
    @AppStorage(Constants.Keys.isSavedOnKeyChain) private var isSavedOnKeyChain = false
    @AppStorage(Constants.Keys.username) private var username: String = ""
    @Environment(AppViewModel.self) private var appVM: AppViewModel
    @State private var verifyType: VerifyType?
    @State private var password: String = ""
    @State private var code: String = ""
    @State private var isRequesting = false
    @State private var isPresentedPopover = false

    var body: some View {
        VStack(spacing: 16) {
            if verifyType == nil {
                loginViewGroup
            } else {
                otpViewGroup
            }
        }
        .padding(32)
        .ignoresSafeArea(.keyboard)
        .onAppear {
            if isSavedOnKeyChain,
               let password = KeychainUtil.shared.getPassword(for: username) {
                self.password = password
            }
        }
    }

    @ViewBuilder private var loginViewGroup: some View {
        loginFields
        loginButton("Login") {
            verifyType = await appVM.login(
                username: username,
                password: password,
                isSavedOnKeyChain: isSavedOnKeyChain
            )
        }
    }

    @ViewBuilder private var otpViewGroup: some View {
        otpField
        loginButton("Continue") {
            await appVM.verifyTwoFA(verifyType, code)
        }
    }

    private var loginFields: some View {
        VStack(spacing: 8) {
            TextField("UserName", text: $username)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            Toggle(isOn: $isSavedOnKeyChain) {
                HStack {
                    Label {
                        Text("Store in Keychain")
                    } icon: {
                        Image(systemName: "key.icloud")
                    }
                    Button {
                        isPresentedPopover.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                    .popover(isPresented: $isPresentedPopover) {
                        Text(helpText)
                            .padding()
                            .presentationDetents([.fraction(1/4)])
                    }
                }
                .font(.callout)
                .foregroundStyle(Color(uiColor: .systemGray))
            }
        }
        .padding(.horizontal, 8)
    }

    let helpText = """
            Using iCloud Keychain to securely store your passwords. \
            iCloud Keychain is built on security technologies provided by Apple, \
            ensuring that your passwords are encrypted \
            and protected from unauthorized access.
            """

    private var otpField: some View {
        TextField("Code", text: $code)
            .keyboardType(.decimalPad)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 8)
    }

    @ViewBuilder
    private func loginButton(_ text: String, action: @escaping () async -> Void) -> some View {
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
