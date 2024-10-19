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
    var isLoggingIn = false
    var isRequiredReAuthentication = false
    var services: APIServiceUtil
    var verifyType: VerifyType?
    @ObservationIgnored var client: APIClient

    init() {
        let client = APIClient()
        self.client = client
        services = APIServiceUtil(client: client)
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

    private func isPreviewUser(username: String, password: String) -> Bool {
        username == Constants.Values.previewUser && password == Constants.Values.previewUser
    }

    private func setCredential(username: String, password: String, isSavedOnKeyChain: Bool) async {
        services = APIServiceUtil(isPreviewMode: isPreviewUser(username: username, password: password), client: client)
        await client.setCledentials(username: username, password: password)
        if isSavedOnKeyChain {
            _ = await KeychainUtil.shared.savePassword(password, for: username)
        }
    }

    func login(username: String, password: String, isSavedOnKeyChain: Bool) async {
        await setCredential(username: username, password: password, isSavedOnKeyChain: isSavedOnKeyChain)
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
        defer { isLoggingIn = false }
        var result: Either<User, VerifyType>?
        isLoggingIn = true
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

    func logout(service: AuthenticationServiceProtocol) async {
        do {
            try await service.logout()
            reset()
        } catch {
            handleError(error)
        }
    }

    private func reset() {
        step = .initializing
        client = APIClient()
    }

    func handleError(_ error: Error) {
        if let error = error as? VRCKitError {
            if error == .unauthorized, step != .loggingIn {
                isRequiredReAuthentication = true
                return
            }
            vrckError = error
        } else if !isCancelled(error) {
            vrckError = .unexpected
        }
        isPresentedAlert = vrckError != nil
    }

    private func isCancelled(_ error: Error) -> Bool {
        (error as NSError?)?.isCancelled ?? false
    }
}

extension AppViewModel {
    /// Initialize as preview mode
    /// - Parameter isPreviewMode
    convenience init(isPreviewMode: Bool) {
        self.init()
        services = APIServiceUtil(isPreviewMode: true, client: client)
        user = PreviewDataProvider.shared.previewUser
    }
}
