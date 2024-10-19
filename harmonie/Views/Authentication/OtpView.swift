//
//  OtpView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/31.
//

import AsyncSwiftUI
import VRCKit

struct OtpView: View {
    @Environment(AppViewModel.self) var appVM
    @State private var code: String = ""
    @State private var isRequesting = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Two-step verification")
                .font(.headline)
            VStack {
                TextField("Code", text: $code)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 120)
                Text(explanation)
                    .foregroundStyle(.gray)
                    .font(.caption2)
            }
            .padding(.horizontal, 8)
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
        await appVM.verifyTwoFA(code: code)
    }

    private var explanation: LocalizedStringKey {
        "Enter the 6-digit two-factor verification code recieved in your \(verifyTypeDescription)."
    }

    private var verifyTypeDescription: String {
        appVM.verifyType?.description ?? ""
    }

    private var isDisabledEnterButton: Bool {
        isRequesting || code.count < 6
    }
}

extension VerifyType: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .emailOtp:
            String(localized: "email")
        case .otp, .totp:
            String(localized: "authenticator app")
        }
    }
}

#Preview {
    OtpView()
        .environment(AppViewModel())
}
