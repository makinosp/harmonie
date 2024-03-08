//
//  LoginView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/08.
//

import SwiftUI
import VRCKit

struct LoginView: View {
    @Binding var client: APIClientAsync
    @State var requiresTwoFactorAuth: [String] = []
    @State var username: String = ""
    @State var password: String = ""
    @State var code: String = ""
    @State var user: User?

    var body: some View {
        Form {
            if requiresTwoFactorAuth.isEmpty {
                usernamePasswordFields
            } else {
                otpField
            }
        }
    }

    var usernamePasswordFields: some View {
        Form {
            TextField("UserName", text: $username)
            SecureField("Password", text: $password)
            Button("Login") {
                client = APIClientAsync(
                    username: username,
                    password: password
                )
                Task {
                    let wrappedUser = try await AuthenticationService.loginUserInfo(client)
                    self.user = wrappedUser.user
                    self.requiresTwoFactorAuth = wrappedUser.requiresTwoFactorAuth
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    var otpField: some View {
        Group {
            TextField("Code", text: $code)
            Button("OK") {
                Task {
                    var verifyType: String?
                    if requiresTwoFactorAuth.contains(TwoFactorAuthType.totp.rawValue) {
                        verifyType = TwoFactorAuthType.totp.rawValue
                    } else if requiresTwoFactorAuth.contains(TwoFactorAuthType.emailotp.rawValue) {
                        verifyType = TwoFactorAuthType.emailotp.rawValue
                    }
                    guard let verifyType = verifyType else { return }
                    let isSucceeded = try await AuthenticationService.verify2FA(
                        client,
                        verifyType: verifyType,
                        code: code
                    )
                    if isSucceeded {
                        self.user = try await AuthenticationService.loginUserInfo(client).user
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
