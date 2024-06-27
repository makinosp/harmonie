//
//  UserData.swift
//  harmonie
//
//  Created by makinosp on 2024/03/09.
//

import Foundation
import VRCKit

@MainActor
class UserData: ObservableObject {
    @Published var user: User?
    @Published var step: Step = .initializing
    @Published var isPresentedAlert = false
    @Published var vrckError: VRCKitError? = nil
    @Published var client = APIClient()

    public enum Step: Equatable {
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
    func setup() async -> UserData.Step {
        typealias Service = AuthenticationService
        // check local data
        if client.isEmptyCookies {
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

    func logout() async {
        do {
            try await AuthenticationService.logout(client)
        } catch {
            handleError(error)
        }
        reset()
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
