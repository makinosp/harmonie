//
//  AuthenticationView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/08.
//

import AsyncSwiftUI
import VRCKit

struct AuthenticationView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State var verifyType: VerifyType?
    @State var username: String = ""
    @State var password: String = ""
    @State var code: String = ""
    @State var isRunning = false

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

    var usernamePasswordFields: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "at")
                    .foregroundStyle(Color.gray)
                TextField("UserName", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 8)
            HStack {
                Image(systemName: "lock")
                    .foregroundStyle(Color.gray)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 8)
        }
    }

    var otpField: some View {
        HStack {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.gray)
            TextField("Code", text: $code)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(UIColor.systemBackground))
        )
    }

    @ViewBuilder
    func loginButton(
        _ text: String,
        _ action: @escaping () async -> Void
    ) -> some View {
        AsyncButton {
            isRunning = true
            await action()
            isRunning = false
        } label: {
            if isRunning {
                ProgressView()
            } else {
                Text(text)
            }
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .disabled(isRunning)
    }
}
