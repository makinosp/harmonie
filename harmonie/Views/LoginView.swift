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
    @State var requiresTwoFactorAuth: [String] = []
    @State var username: String = ""
    @State var password: String = ""
    @State var code: String = ""

    @State var isRunning = false
    @State var isPresentedAlert = false
    @State var vrckError: VRCKitError? = nil

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
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
        .edgesIgnoringSafeArea(.all)
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
                        .foregroundStyle(Color(UIColor.systemBackground))
                )
                HStack {
                    Image(systemName: "lock")
                        .foregroundStyle(Color.gray)
                    SecureField("Password", text: $password)
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(UIColor.systemBackground))
                )
            }
            if isRunning {
                ProgressView()
            } else {
                AsyncButton {
                    await login()
                } label: {
                    Label("Login", systemImage: "chevron.right")
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
                    .foregroundStyle(Color(UIColor.systemBackground))
            )
            if isRunning {
                ProgressView()
            } else {
                AsyncButton {
                    await verifyTwoFA()
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

    func login() async {
        userData.client = APIClient(
            username: username,
            password: password
        )
        do {
            switch try await AuthenticationService.loginUserInfo(userData.client) {
            case let value as [String]:
                requiresTwoFactorAuth = value
            case let value as User:
                userData.user = value
                userData.step = .done(user: value)
            default:
                isPresentedAlert = true
                vrckError = .unexpectedError
            }
        } catch let error as VRCKitError {
            isPresentedAlert = true
            vrckError = error
        } catch {
            isPresentedAlert = true
            vrckError = .unexpectedError
        }
    }

    func verifyTwoFA() async {
        var verifyType: String?
        if requiresTwoFactorAuth.contains(TwoFactorAuthType.totp.rawValue) {
            verifyType = TwoFactorAuthType.totp.rawValue
        } else if requiresTwoFactorAuth.contains(TwoFactorAuthType.emailotp.rawValue) {
            verifyType = TwoFactorAuthType.emailotp.rawValue
        }
        guard let verifyType = verifyType else { return }
        do {
            if try await AuthenticationService.verify2FA(
                userData.client,
                verifyType: verifyType,
                code: code
            ) {
                userData.step = .loggedIn
            } else {
                // TODO: throw error
                print("not verified")
            }
        } catch let error as VRCKitError {
            isPresentedAlert = true
            vrckError = error
        } catch {
            isPresentedAlert = true
            vrckError = .unexpectedError
        }
    }
}
