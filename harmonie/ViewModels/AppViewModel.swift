//
//  AppViewModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/09.
//

import Foundation
import Observation
import VRCKit

@Observable
final class AppViewModel {
    var user: User?
    var step: Step = .initializing
    var isPresentedAlert = false
    var vrckError: VRCKitError?
    var isDemoMode = false
    @ObservationIgnored var client = APIClient()

    enum Step: Equatable {
        case initializing, loggingIn, done(User)
    }

    /// Check the authentication status of the user,
    /// fetch the user information, and perform the initialization process.
    /// - Returns: Depending on the status, either `loggingIn` or `done` is returned.
    func setup(service: any AuthenticationServiceProtocol) async -> Step {
        // check local data
        guard !client.cookieManager.cookies.isEmpty else {
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

    func login(username: String, password: String, isSavedOnKeyChain: Bool) async -> VerifyType? {
        if username == "demo" && password == "demo" {
            isDemoMode = true
        } else {
            client.setCledentials(username: username, password: password)
        }
        if isSavedOnKeyChain {
           _ = KeychainUtil.shared.savePassword(password, for: username)
        }
        let service = isDemoMode
            ? AuthenticationPreviewService(client: client)
            : AuthenticationService(client: client)
        do {
            switch try await service.loginUserInfo() {
            case let verifyType as VerifyType:
                return verifyType
            case let user as User:
                self.user = user
                step = .done(user)
            default: break
            }
        } catch {
            handleError(error)
        }
        return nil
    }

    func verifyTwoFA(
        service: any AuthenticationServiceProtocol,
        verifyType: VerifyType?,
        code: String
    ) async {
        do {
            defer {
                reset()
            }
            guard let verifyType = verifyType else {
                throw Errors.dataError
            }
            guard try await service.verify2FA(
                verifyType: verifyType,
                code: code
            ) else {
                throw Errors.dataError
            }
        } catch {
            handleError(error)
        }
    }

    func logout(service: any AuthenticationServiceProtocol) async {
        do {
            try await service.logout()
            reset()
        } catch {
            handleError(error)
        }
    }

    private func reset() {
        user = nil
        step = .initializing
        client = APIClient()
    }

    func handleError(_ error: Error) {
        if let error = error as? VRCKitError {
            if error == .unauthorized {
                step = .loggingIn
            } else {
                vrckError = error
            }
        } else if !isCancelled(error) {
            vrckError = .unexpected
        }
        isPresentedAlert = vrckError != nil
    }

    private func isCancelled(_ error: Error) -> Bool {
        (error as NSError?)?.isCancelled ?? false
    }
}
