//
//  AuthenticationView+Otp.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/31.
//

import SwiftUI

extension AuthenticationView {
    @ViewBuilder var otpViewGroup: some View {
        otpField
        loginButton("Continue") {
            await appVM.verifyTwoFA(verifyType, code)
        }
    }

    private var otpField: some View {
        TextField("Code", text: $code)
            .keyboardType(.decimalPad)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 8)
    }
}

#Preview {
    AuthenticationView(verifyType: .totp)
        .environment(AppViewModel())
}
