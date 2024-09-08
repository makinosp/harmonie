//
//  AuthenticationView+Login.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/31.
//

import AsyncSwiftUI

extension AuthenticationView {
    var loginView: some View {
        VStack(spacing: 16) {
            loginFields
            loginButton("Login") {
                verifyType = await appVM.login(
                    service: authenticationService,
                    username: username,
                    password: password,
                    isSavedOnKeyChain: isSavedOnKeyChain
                )
            }
        }
        .padding(32)
        .ignoresSafeArea(.keyboard)
        .onAppear {
            if isSavedOnKeyChain,
               let password = KeychainUtil.shared.getPassword(for: username) {
                self.password = password
            }
        }
    }

    private var loginFields: some View {
        VStack(spacing: 8) {
            TextField("UserName", text: $username)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            Toggle(isOn: $isSavedOnKeyChain) {
                HStack {
                    Label {
                        Text("Store in Keychain")
                    } icon: {
                        Image(systemName: "key.icloud")
                    }
                    Button {
                        isPresentedPopover.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                    .popover(isPresented: $isPresentedPopover) {
                        Text(Constants.Messages.helpWithStoringKeychain)
                            .padding()
                            .presentationDetents([.fraction(1/4)])
                    }
                }
                .font(.callout)
                .foregroundStyle(Color(uiColor: .systemGray))
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    AuthenticationView()
        .environment(AppViewModel())
}
