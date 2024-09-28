//
//  OtpView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/31.
//

import AsyncSwiftUI
import VRCKit

struct OtpView: View, AuthenticationServicePresentable {
    @Environment(AppViewModel.self) var appVM
    @State private var code: String = ""
    @State private var isRequesting = false
    private let verifyType: VerifyType

    init(verifyType: VerifyType) {
        self.verifyType = verifyType
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Two-step verification")
                .font(.headline)
            Text("Enter the 6-digit two-factor verification code recieved in your \(verifyType.method).")
                .foregroundStyle(Color(.systemGray))
                .font(.body)
            TextField("Code", text: $code)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 8)
                .frame(maxWidth: 240)
            enterButton
        }
        .padding(32)
        .ignoresSafeArea(.keyboard)
    }

    private var enterButton: some View {
        AsyncButton {
            await otpAction()
        } label: {
            if isRequesting {
                ProgressView()
            } else {
                Text("Enter")
            }
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .disabled(isDisabledEnterButton)
    }

    private func otpAction() async {
        defer { isRequesting = false }
        isRequesting = true
        await appVM.verifyTwoFA(
            service: authenticationService,
            verifyType: verifyType,
            code: code
        )
    }

    private var isDisabledEnterButton: Bool {
        isRequesting || code.count < 6
    }
}

extension VerifyType {
    var method: String {
        switch self {
        case .emailOtp: "email"
        default: "authenticator app"
        }
    }
}

#Preview {
    OtpView(verifyType: .totp)
        .environment(AppViewModel())
}
