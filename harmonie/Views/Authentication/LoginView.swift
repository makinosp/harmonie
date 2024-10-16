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
    @State private var isPresentedSecurityPopover = false
    @State private var isPresentedSavingPasswordPopover = false
    private let titleFont = "Avenir Next"

    var body: some View {
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
                Label("Save Password", systemImage: IconSet.key.systemName)
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

    private func loginAction() async {
        verifyType = await appVM.login(
            username: username,
            password: password,
            isSavedOnKeyChain: isSavedOnKeyChain
        )
    }

    private var isDisabledEnterButton: Bool {
        appVM.isLoggingIn || username.count < 4 || password.count < 8
    }
}

#Preview {
    LoginView()
        .environment(AppViewModel())
}
