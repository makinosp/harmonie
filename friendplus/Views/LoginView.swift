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
    @Binding var isValidToken: Bool?
    @State var requiresTwoFactorAuth: [String] = []
    @State var username: String = ""
    @State var password: String = ""
    @State var code: String = ""

    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            if requiresTwoFactorAuth.isEmpty {
                usernamePasswordFields
            } else {
                otpField
            }
        }
    }

    var usernamePasswordFields: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "at")
                        .foregroundStyle(Color.gray)
                    TextField("UserName", text: $username)
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.white)
                )
                HStack {
                    Image(systemName: "lock")
                        .foregroundStyle(Color.gray)
                    SecureField("Password", text: $password)
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.white)
                )
            }
            Button {
                userData.client = APIClient(
                    username: username,
                    password: password
                )
                Task {
                    let response = try await AuthenticationService.loginUserInfo(userData.client)
                    switch response {
                    case .requiresTwoFactorAuth(let factors):
                        self.requiresTwoFactorAuth = factors
                    case .user(let user):
                        print(user)
                    case .failure(let failure):
                        print(failure)
                    }

                }
            } label: {
                Image(systemName: "arrow.right")
                    .bold()
                    .font(.title2)
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding(24)
    }

    var otpField: some View {
        VStack(spacing: 24) {
            HStack {
                Image(systemName: "ellipsis")
                    .foregroundStyle(Color.gray)
                TextField("Code", text: $code)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.white)
            )
            Button {
                Task {
                    var verifyType: String?
                    if requiresTwoFactorAuth.contains(TwoFactorAuthType.totp.rawValue) {
                        verifyType = TwoFactorAuthType.totp.rawValue
                    } else if requiresTwoFactorAuth.contains(TwoFactorAuthType.emailotp.rawValue) {
                        verifyType = TwoFactorAuthType.emailotp.rawValue
                    }
                    guard let verifyType = verifyType else { return }
                    isValidToken = try await AuthenticationService.verify2FA(
                        userData.client,
                        verifyType: verifyType,
                        code: code
                    )
                }
            } label: {
                Image(systemName: "arrow.right")
                    .bold()
                    .font(.title2)
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding(24)
    }
}
