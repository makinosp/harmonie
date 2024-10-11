//
//  LoginView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/31.
//

import AsyncSwiftUI
import VRCKit

struct LoginView: View, AuthenticationServiceRepresentable {
    @AppStorage(Constants.Keys.isSavedOnKeyChain) private var isSavedOnKeyChain = false
    @AppStorage(Constants.Keys.username) private var username = ""
    @Environment(AppViewModel.self) var appVM
    @State private var verifyType: VerifyType?
    @State private var password = ""
    @State private var isRequesting = false
    @State private var isPresentedSecurityPopover = false
    @State private var isPresentedSavingPasswordPopover = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                title
                loginFields
                keychainToggle
                enterButton
            }
            .frame(maxWidth: 560)
            .padding(.horizontal, 32)
            .navigationDestination(item: $verifyType) { verifyType in
                OtpView(verifyType: verifyType)
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
        Text(BundleUtil.appName.uppercased())
            .font(.custom("Avenir Next", size: titleFontSize))
            .kerning(titleKerning)
    }

    private var titleFontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 56 : 28
    }

    private var titleKerning: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 28 : 14
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
                    annotation(
                        title: "Is this secure?",
                        text: Constants.Messages.helpWithLoginSafety,
                        isPresented: $isPresentedSecurityPopover
                    )
                }
            }
        }
    }

    private var keychainToggle: some View {
        Toggle(isOn: $isSavedOnKeyChain) {
            LabeledContent {
                Button {
                    isPresentedSavingPasswordPopover.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                }
                .popover(isPresented: $isPresentedSavingPasswordPopover) {
                    annotation(
                        title: "In What Way?",
                        text: Constants.Messages.helpWithStoringKeychain,
                        isPresented: $isPresentedSavingPasswordPopover
                    )
                }
            } label: {
                Label {
                    Text("Save Password")
                } icon: {
                    Image(systemName: "key.icloud")
                }
                .foregroundStyle(Color(.systemGray))
            }
            .font(.callout)
        }
    }

    private func annotation(
        title: LocalizedStringKey,
        text: String,
        isPresented: Binding<Bool>
    ) -> some View {
        NavigationStack {
            Text(text)
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .foregroundStyle(Color(.systemGray))
                .padding()
                .presentationDetents([.medium])
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            isPresented.wrappedValue.toggle()
                        }
                    }
                }
        }
    }

    private var enterButton: some View {
        AsyncButton {
            await loginAction()
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

    private func loginAction() async {
        defer { isRequesting = false }
        isRequesting = true
        verifyType = await appVM.login(
            username: username,
            password: password,
            isSavedOnKeyChain: isSavedOnKeyChain
        )
    }

    private var isDisabledEnterButton: Bool {
        isRequesting || username.count < 4 || password.count < 8
    }
}

#Preview {
    LoginView()
        .environment(AppViewModel())
}
