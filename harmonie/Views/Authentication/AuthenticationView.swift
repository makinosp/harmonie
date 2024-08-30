//
//  AuthenticationView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/08.
//

import AsyncSwiftUI
import VRCKit

struct AuthenticationView: View {
    @Environment(AppViewModel.self) private var appVM: AppViewModel
    @State private var verifyType: VerifyType?
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var code: String = ""
    @State private var isRequesting = false

    var body: some View {
        VStack(spacing: 16) {
            if verifyType == nil {
                usernamePasswordFields
                loginButton("Login") {
                    verifyType = await appVM.login(username, password)
                }
            } else {
                otpField
                loginButton("Continue") {
                    await appVM.verifyTwoFA(verifyType, code)
                }
            }
        }
        .padding(32)
        .ignoresSafeArea(.keyboard)
    }

    private var usernamePasswordFields: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "at")
                    .foregroundStyle(Color.gray)
                TextField("UserName", text: $username)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal, 8)
            HStack {
                Image(systemName: "lock")
                    .foregroundStyle(Color.gray)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal, 8)
        }
    }

    private var otpField: some View {
        HStack {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.gray)
            TextField("Code", text: $code)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(uiColor: .systemBackground))
        )
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
