//
//  AppViewModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/09.
//

import Foundation
import Observation
import VRCKit

@Observable @MainActor
final class AppViewModel {
    var user: User?
    var step: Step = .initializing
    var isPresentedAlert = false
    var vrckError: VRCKitError?
    var isRequesting = false
    var services: APIServiceUtil
    var verifyType: VerifyType?
    @ObservationIgnored var client: APIClient
    @ObservationIgnored let userDefaults: UserDefaults

    init() {
        let client = APIClient()
        self.client = client
        services = APIServiceUtil(client: client)
        userDefaults = UserDefaults.standard
    }

    enum Step: Equatable {
        case initializing, loggingIn, done(User)
    }

    /// Check the authentication status of the user,
    /// fetch the user information, and perform the initialization process.
    /// - Returns: Depending on the status, either `loggingIn` or `done` is returned.
    func setup(service: AuthenticationServiceProtocol) async -> Step {
        var next: Step = .loggingIn
        // check local data
        guard await client.cookieManager.cookieExists else { return next }
        do {
            // verify auth token and fetch user data
            guard try await service.verifyAuthToken() else { return next }
            let result = try await service.loginUserInfo()
            if case .left(let user) = result {
                self.user = user
                next = .done(user)
            }
        } catch {
            handleError(error)
        }
        return next
    }

    private func setCredential(_ credential: Credential, isSavedOnKeyChain: Bool) async {
        services = APIServiceUtil(isPreviewMode: credential.isPreviewUser, client: client)
        await client.setCledentials(credential)
        if isSavedOnKeyChain {
            _ = await KeychainUtil.shared.savePassword(credential)
        }
    }

    func login(credential: Credential, isSavedOnKeyChain: Bool) async {
        await setCredential(credential, isSavedOnKeyChain: isSavedOnKeyChain)
        guard let result = await login() else { return }
        loginHandler(result: result)
    }

    private func loginHandler(result: Either<User, VerifyType>) {
        switch result {
        case .left(let user):
            setUser(user)
        case .right(let verifyType):
            self.verifyType = verifyType
        }
    }

    private func setUser(_ user: User) {
        self.user = user
        step = .done(user)
    }

    func login() async -> Either<User, VerifyType>? {
        defer { isRequesting = false }
        var result: Either<User, VerifyType>?
        isRequesting = true
        do {
            result = try await services.authenticationService.loginUserInfo()
        } catch {
            handleError(error)
        }
        return result
    }

    func verifyTwoFA(code: String) async {
        guard let verifyType = verifyType else { return }
        do {
            defer { reset() }
            guard try await services.authenticationService.verify2FA(
                verifyType: verifyType,
                code: code
            ) else {
                throw ApplicationError(text: "Authentication failed")
            }
        } catch {
            handleError(error)
        }
    }

    func logout() async {
        do {
            try await services.authenticationService.logout()
            reset()
        } catch {
            handleError(error)
        }
    }

    private func reset() {
        userDefaults.removeObject(forKey: Constants.Keys.isSavedOnKeyChain.rawValue)
        userDefaults.removeObject(forKey: Constants.Keys.username.rawValue)
        step = .initializing
        client = APIClient()
    }

    func handleError(_ error: Error) {
        if let error = error as? VRCKitError {
            guard error != .unauthorized else {
                step = .loggingIn
                return
            }
            vrckError = error
        } else if !error.isCancelled {
            vrckError = .unexpected
        }
        isPresentedAlert = vrckError != nil
    }
}
