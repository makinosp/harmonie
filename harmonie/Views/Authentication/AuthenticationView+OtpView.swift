//
//  AuthenticationView+Otp.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/31.
//

import SwiftUI

extension AuthenticationView {
    var otpView: some View {
        VStack(spacing: 16) {
            TextField("Code", text: $code)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 8)
            loginButton("Continue") {
                await appVM.verifyTwoFA(
                    service: authenticationService,
                    verifyType: verifyType,
                    code: code
                )
            }
        }
        .padding(32)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    AuthenticationView(verifyType: .totp)
        .environment(AppViewModel())
}
