//
//  UserData.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/09.
//

import Foundation
import Observation
import VRCKit

@MainActor @Observable
class AppViewModel {
    var user: User?
    var step: Step = .initializing
    var isPresentedAlert = false
    var vrckError: VRCKitError?
    var isDemoMode = false
    @ObservationIgnored var client = APIClient()
    @ObservationIgnored var service: any AuthenticationServiceProtocol

    init() {
        self.service = AuthenticationService(client: client)
    }

    enum Step: Equatable {
        case initializing, loggingIn, done(User)
    }

    func setDemoMode() {
        isDemoMode = true
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
            return .done(user)
        } catch {
            handleError(error)
            return .loggingIn
        }
    }

    func login(username: String, password: String, isSavedOnKeyChain: Bool) async -> VerifyType? {
        if username == "demo" && password == "demo" {
            setDemoMode()
        } else {
            client.setCledentials(username: username, password: password)
        }
        if isSavedOnKeyChain {
           _ = KeychainUtil.shared.savePassword(password, for: username)
        }
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

    func generateFriendVM(user: User) -> FriendViewModel {
        let service = isDemoMode ? FriendPreviewService(client: client) : FriendService(client: client)
        return FriendViewModel(user: user, service: service)
    }

    func generateFavoriteVM(friendVM: FriendViewModel) -> FavoriteViewModel {
        let service = isDemoMode ? FavoritePreviewService(client: client) : FavoriteService(client: client)
        return FavoriteViewModel(friendVM: friendVM, service: service)
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
        } else if (error as NSError?)?.isCancelled ?? false {
            return
        } else {
            vrckError = .unexpectedError
        }
        isPresentedAlert = true
    }
}

fileprivate extension NSError {
    /// A Boolean value indicating whether the error represents a cancelled network request.
    var isCancelled: Bool {
        self.domain == NSURLErrorDomain && self.code == NSURLErrorCancelled
    }
}
