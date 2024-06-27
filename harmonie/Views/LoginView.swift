//
//  LoginView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/08.
//

import AsyncSwiftUI
import VRCKit

struct LoginView: View {
    @EnvironmentObject var userData: UserData
    @State var verifyType: VerifyType?
    @State var username: String = ""
    @State var password: String = ""
    @State var code: String = ""

    @State var isRunning = false
    @State var isPresentedAlert = false
    @State var vrckError: VRCKitError? = nil

    private typealias Service = AuthenticationService

    var body: some View {
        VStack(spacing: 16) {
            if verifyType == nil {
                usernamePasswordFields
                loginButton("Login", login)
            } else {
                otpField
                loginButton("Continue", verifyTwoFA)
            }
        }
        .padding(32)
        .ignoresSafeArea(.keyboard)
        .alert(isPresented: $isPresentedAlert, error: vrckError) { _ in
            Button("OK") {}
        } message: { error in
            Text(error.failureReason ?? "Try again later.")
        }
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
            await action()
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

    func login() async {
        isRunning = true
        userData.client = APIClient(
            username: username,
            password: password
        )
        do {
            defer { isRunning = false }
            switch try await Service.loginUserInfo(userData.client) {
            case let value as VerifyType:
                verifyType = value
            case let value as User:
                userData.user = value
                userData.step = .done
            default:
                isPresentedAlert = true
                vrckError = .unexpectedError
            }
        } catch {
            userData.handleError(error)
        }
    }

    func verifyTwoFA() async {
        isRunning = true
        guard let verifyType = verifyType else {
            return
        }
        do {
            defer { isRunning = false }
            guard try await Service.verify2FA(
                userData.client,
                verifyType: verifyType,
                code: code
            ) else {
                // TODO: reset login process
                return
            }
            userData.reset()
        } catch {
            userData.handleError(error)
        }
    }
}
