//
//  LoginView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/08.
//

import SwiftUI
import VRCKit

struct LoginView: View {
    @EnvironmentObject var userData: UserData
    @State var requiresTwoFactorAuth: [String] = []
    @State var username: String = ""
    @State var password: String = ""
    @State var code: String = ""

    var body: some View {
        if requiresTwoFactorAuth.isEmpty {
            usernamePasswordFields
        } else {
            otpField
        }
    }

    var usernamePasswordFields: some View {
        Form {
            TextField("UserName", text: $username)
            SecureField("Password", text: $password)
            Button("Login") {
                userData.client = APIClientAsync(
                    username: username,
                    password: password
                )
                Task {
                    let wrappedUser = try await AuthenticationService.loginUserInfo(userData.client)
                    self.requiresTwoFactorAuth = wrappedUser.requiresTwoFactorAuth
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    var otpField: some View {
        Form {
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
                    let _ = try await AuthenticationService.verify2FA(
                        userData.client,
                        verifyType: verifyType,
                        code: code
                    )
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
