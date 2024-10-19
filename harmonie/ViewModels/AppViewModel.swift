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
    var isPreviewMode = false
    var isLoggingIn = false
    var isRequiredReAuthentication = false
    var services: APIServiceUtil
    @ObservationIgnored var client: APIClient
    @ObservationIgnored lazy var authenticationService = lazyAuthenticationService
    @ObservationIgnored lazy var instanceService = lazyInstanceService
    @ObservationIgnored lazy var userNoteService = lazyUserNoteService
    @ObservationIgnored lazy var userService = lazyUserService
    @ObservationIgnored lazy var worldService = lazyWorldService

    init() {
        let client = APIClient()
        self.client = client
        services = APIServiceUtil(isPreviewMode: false, client: client)
    }

    enum Step: Equatable {
        case initializing, loggingIn, done(User)
    }

    private func resetLazyProperties() {
        authenticationService = lazyAuthenticationService
        instanceService = lazyInstanceService
        userNoteService = lazyUserNoteService
        userService = lazyUserService
        worldService = lazyWorldService
    }

    private var lazyAuthenticationService: AuthenticationServiceProtocol {
        isPreviewMode ? AuthenticationPreviewService(client: client) : AuthenticationService(client: client)
    }

    private var lazyInstanceService: InstanceServiceProtocol {
        isPreviewMode ? InstancePreviewService(client: client) : InstanceService(client: client)
    }

    private var lazyUserNoteService: UserNoteServiceProtocol {
        isPreviewMode ? UserNotePreviewService(client: client) : UserNoteService(client: client)
    }

    private var lazyUserService: UserServiceProtocol {
        isPreviewMode ? UserPreviewService(client: client) : UserService(client: client)
    }

    private var lazyWorldService: WorldServiceProtocol {
        isPreviewMode ? WorldPreviewService(client: client) : WorldService(client: client)
    }

    /// Check the authentication status of the user,
    /// fetch the user information, and perform the initialization process.
    /// - Returns: Depending on the status, either `loggingIn` or `done` is returned.
    func setup(service: AuthenticationServiceProtocol) async -> Step {
        // check local data
        guard await !client.cookieManager.cookies.isEmpty else {
            return .loggingIn
        }
        do {
            // verify auth token and fetch user data
            guard try await service.verifyAuthToken(),
                  let user = try await service.loginUserInfo() as? User else {
                return .loggingIn
            }
            self.user = user
            return .done(user)
        } catch {
            handleError(error)
            return .loggingIn
        }
    }

    private func isPreviewUser(username: String, password: String) -> Bool {
        username == Constants.Values.previewUser && password == Constants.Values.previewUser
    }

    private func setCredential(username: String, password: String, isSavedOnKeyChain: Bool) async {
        isPreviewMode = isPreviewUser(username: username, password: password)
        resetLazyProperties()
        await client.setCledentials(username: username, password: password)
        if isSavedOnKeyChain {
            _ = await KeychainUtil.shared.savePassword(password, for: username)
        }
    }

    func login(username: String, password: String, isSavedOnKeyChain: Bool) async -> VerifyType? {
        await setCredential(username: username, password: password, isSavedOnKeyChain: isSavedOnKeyChain)
        return await login()
    }

    func login() async -> VerifyType? {
        defer { isLoggingIn = false }
        isLoggingIn = true
        do {
            switch try await authenticationService.loginUserInfo() {
            case let verifyType as VerifyType:
                return verifyType
            case let user as User:
                self.user = user
                if step != .done(user) {
                    step = .done(user)
                }
            default: break
            }
        } catch {
            handleError(error)
        }
        return nil
    }

    func verifyTwoFA(verifyType: VerifyType, code: String) async {
        do {
            defer { reset() }
            guard try await authenticationService.verify2FA(
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
        isPreviewMode = false
        resetLazyProperties()
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
        self.isPreviewMode = isPreviewMode
        resetLazyProperties()
        user = PreviewDataProvider.shared.previewUser
        authenticationService = AuthenticationPreviewService(client: client)
    }
}
