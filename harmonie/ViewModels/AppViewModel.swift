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
    var vrckError: VRCKitError?
    var applicationError: ApplicationError?
    var services: APIServiceUtil
    var verifyType: VerifyType?
    var screenSize: CGSize = .zero
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

    /// Checks the user's authentication status, fetches user information,
    /// and performs the initialization process.
    ///
    /// - Parameter service: An instance conforming to `AuthenticationServiceProtocol`
    ///                      used to verify the authentication token and fetch user information.
    /// - Returns: A `Step` value indicating the next step:
    ///            `.loggingIn` if the user is not authenticated, or `.done(user)`
    ///            if the authentication and user data retrieval are successful.
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

    /// Sets the user's credentials and configures the necessary services.
    /// - Parameters:
    ///   - credential: The `Credential` object containing user authentication information.
    ///   - isSavedOnKeyChain: A Boolean indicating whether the credential should
    ///                        be saved in the Keychain for future use.
    private func setCredential(_ credential: Credential, isSavedOnKeyChain: Bool) async {
        services = APIServiceUtil(isPreviewMode: credential.isPreviewUser, client: client)
        await client.setCledentials(credential)
        if isSavedOnKeyChain {
            _ = await KeychainUtil.shared.savePassword(credential)
        }
    }

    /// Logs in the user with the provided credentials and handles the login result.
    /// - Parameters:
    ///   - credential: The `Credential` object containing user authentication information.
    ///   - isSavedOnKeyChain: A Boolean indicating whether the credential should
    ///                        be saved in the Keychain for future use.
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

    /// Attempts to log in the user and returns the result of the authentication process.
    /// - Returns: An `Either<User, VerifyType>` value representing the authenticated user
    ///            or a verification type, or `nil` if an error occurs during the process.
    func login() async -> Either<User, VerifyType>? {
        var result: Either<User, VerifyType>?
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
            defer { dispose() }
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
            dispose()
        } catch {
            handleError(error)
        }
    }

    /// Resets the application's state and clears user-related data.
    ///
    /// This function removes stored user data from `UserDefaults`, including the
    /// Keychain save preference and username, resets the current authentication step
    /// to `.initializing`, and reinitializes the API client to a default state.
    private func dispose() {
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
        } else if let error = error as? ApplicationError {
            applicationError = error
        } else if !error.isCancelled {
            applicationError = ApplicationError(error)
        }
    }
}
