//
//  UserData.swift
//  harmonie
//
//  Created by makinosp on 2024/03/09.
//

import Foundation
import VRCKit

@MainActor
class AppViewModel: ObservableObject {
    @Published var user: User?
    @Published var step: Step = .initializing
    @Published var isPresentedAlert = false
    @Published var vrckError: VRCKitError? = nil
    var client = APIClient()

    enum Step: Equatable {
        case initializing, loggingIn, done
    }

    func reset() {
        user = nil
        step = .initializing
        client = APIClient()
    }
    
    /// Check the authentication status of the user,
    /// fetch the user information, and perform the initialization process.
    /// - Returns: Depending on the status, either `loggingIn` or `done` is returned.
    func setup() async -> Step {
        typealias Service = AuthenticationService
        // check local data
        if client.cookies.isEmpty {
            return .loggingIn
        }
        do {
            // verify auth token and fetch user data
            guard try await Service.verifyAuthToken(client),
                  let user = try await Service.loginUserInfo(client) as? User else {
                return .loggingIn
            }
            self.user = user
            return .done
        } catch {
            handleError(error)
            return .loggingIn
        }
    }

    func login(_ username: String, _ password: String) async -> VerifyType? {
        client = APIClient(username: username, password: password)
        do {
            switch try await AuthenticationService.loginUserInfo(client) {
            case let value as VerifyType:
                return value
            case let value as User:
                user = value
                step = .done
            default: break
            }
        } catch {
            handleError(error)
        }
        return nil
    }

    func verifyTwoFA(_ verifyType: VerifyType?, _ code: String) async {
        do {
            defer {
                reset()
            }
            guard let verifyType = verifyType else {
                throw Errors.dataError
            }
            guard try await AuthenticationService.verify2FA(
                client,
                verifyType: verifyType,
                code: code
            ) else {
                throw Errors.dataError
            }
        } catch {
            handleError(error)
        }
    }

    func logout() async {
        do {
            try await AuthenticationService.logout(client)
            reset()
        } catch {
            handleError(error)
        }
    }

    func handleError(_ error: Error) {
        if let error = error as? VRCKitError {
            vrckError = error
        } else {
            vrckError = .unexpectedError
        }
        isPresentedAlert = true
    }
}
