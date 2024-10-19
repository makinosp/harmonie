//
//  LoginView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/31.
//

import AsyncSwiftUI
import VRCKit

struct LoginView: View {
    @AppStorage(Constants.Keys.isSavedOnKeyChain.rawValue) private var isSavedOnKeyChain = false
    @AppStorage(Constants.Keys.username.rawValue) private var username = ""
    @Environment(AppViewModel.self) var appVM
    @State private var password = ""
    @State private var isPresentedSecurityPopover = false
    @State private var isPresentedSavingPasswordPopover = false
    private let titleFont = "Avenir Next"

    var body: some View {
        @Bindable var appVM = appVM
        NavigationStack {
            VStack(spacing: 32) {
                title
                VStack(spacing: 16) {
                    loginFields
                    keychainToggle
                    enterButton
                }
            }
            .frame(maxWidth: 560)
            .padding(.horizontal, 32)
            .navigationDestination(item: $appVM.verifyType) { _ in
                OtpView()
                    .navigationBarBackButtonHidden()
            }
        }
        .ignoresSafeArea(.keyboard)
        .task {
            guard isSavedOnKeyChain else { return }
            if let password = await KeychainUtil.shared.getPassword(for: username) {
                self.password = password
            }
        }
    }

    private var title: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(verbatim: BundleUtil.appName.capitalized)
                .font(.custom(titleFont, size: titleFontSize))
                .fontWeight(.semibold)
            Text(verbatim: "for")
                .fontWeight(.light)
            Text(verbatim: "VRChat")
        }
    }

    private var titleFontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 56 : 28
    }

    private var loginFields: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Username", text: $username)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            HStack {
                Text("Connect your VRChat account.")
                    .font(.footnote)
                    .foregroundStyle(Color(.systemGray))
                Button {
                    isPresentedSecurityPopover.toggle()
                } label: {
                    Text("Is this secure?")
                }
                .font(.footnote)
                .popover(isPresented: $isPresentedSecurityPopover) {
                    let contents: [Constants.Messages] = [
                        .helpWithVRChatAPIAuthencication,
                        .helpWithStoringAuthenticationTokens,
                        .helpWithStoringPassword,
                        .helpWithCommunicationSecurity
                    ]
                    HelpView(title: "Is this secure?", contents: contents)
                }
            }
        }
    }

    private var keychainToggle: Toggle<some View> {
        Toggle(isOn: $isSavedOnKeyChain) {
            LabeledContent {
                Button {
                    isPresentedSavingPasswordPopover.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                }
                .popover(isPresented: $isPresentedSavingPasswordPopover) {
                    HelpView(title: "In What Way?", contents: [.helpWithStoringPassword])
                        .presentationDetents([.medium])
                }
            } label: {
                Label("Save Password", systemImage: IconSet.key.systemName)
                    .foregroundStyle(Color(.systemGray))
            }
            .font(.callout)
        }
    }

    private var enterButton: some View {
        AsyncButton {
            await appVM.login(
                credential: Credential(username: username, password: password),
                isSavedOnKeyChain: isSavedOnKeyChain
            )
        } label: {
            if appVM.isLoggingIn {
                ProgressView()
            } else {
                Text("Enter")
            }
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .disabled(isDisabledEnterButton)
    }

    private var isDisabledEnterButton: Bool {
        appVM.isLoggingIn || username.count < 4 || password.count < 8
    }
}

#Preview {
    LoginView()
        .environment(AppViewModel())
}
