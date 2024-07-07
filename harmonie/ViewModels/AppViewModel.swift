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
    @Published var demoMode = false
    var client = APIClient()
    var service: any AuthenticationServiceProtocol

    init() {
        self.service = AuthenticationService(client: client)
    }

    enum Step: Equatable {
        case initializing, loggingIn, done
    }

    var friendService: any FriendServiceProtocol {
        FriendService(client: client)
    }

    func setDemoMode() {
        demoMode = true
        service = AuthenticationPreviewService(client: client)
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
            return .done
        } catch {
            handleError(error)
            return .loggingIn
        }
    }

    func login(_ username: String, _ password: String) async -> VerifyType? {
        if username == "demo" && password == "demo" {
            setDemoMode()
        } else {
            client.setCledentials(username: username, password: password)
        }
        do {
            switch try await service.loginUserInfo() {
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

    func logout() async {
        do {
            try await service.logout()
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
