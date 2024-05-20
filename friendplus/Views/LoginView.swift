//
//  LoginView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/08.
//

import AsyncSwiftUI
import VRCKit

struct LoginView: View {
    @EnvironmentObject var userData: UserData
    @Binding var isValidToken: Bool?
    @State var requiresTwoFactorAuth: [String] = []
    @State var username: String = ""
    @State var password: String = ""
    @State var code: String = ""

    @State var isRunning = false
    @State var isPresentedAlert = false
    @State var vrckError: VRCKitError? = nil

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
        .alert(isPresented: $isPresentedAlert, error: vrckError) { _ in
            Button("OK") {}
        } message: { error in
            Text(error.failureReason ?? "Try again later.")
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
            if isRunning {
                ProgressView()
            } else {
                AsyncButton {
                    userData.client = APIClient(
                        username: username,
                        password: password
                    )
                    do {
                        switch try await AuthenticationService.loginUserInfo(userData.client) {
                        case let value as [String]:
                            self.requiresTwoFactorAuth = value
                        default:
                            break
                        }
                    } catch let error as VRCKitError {
                        isPresentedAlert = true
                        vrckError = error
                    } catch {
                        vrckError = .unexpectedError
                    }
                } label: {
                    Label("Sign In", systemImage: "chevron.right")
                }
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
            if isRunning {
                ProgressView()
            } else {
                AsyncButton {
                    var verifyType: String?
                    if requiresTwoFactorAuth.contains(TwoFactorAuthType.totp.rawValue) {
                        verifyType = TwoFactorAuthType.totp.rawValue
                    } else if requiresTwoFactorAuth.contains(TwoFactorAuthType.emailotp.rawValue) {
                        verifyType = TwoFactorAuthType.emailotp.rawValue
                    }
                    guard let verifyType = verifyType else { return }
                    do {
                        isValidToken = try await AuthenticationService.verify2FA(
                            userData.client,
                            verifyType: verifyType,
                            code: code
                        )
                    } catch let error as VRCKitError {
                        isPresentedAlert = true
                        vrckError = error
                    } catch {
                        vrckError = .unexpectedError
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
        }
        .padding(24)
    }
}
