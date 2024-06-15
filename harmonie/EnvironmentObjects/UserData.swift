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
    var client = APIClient()

    public enum Step: Equatable {
        case initializing
        case loggingIn
        case loggedIn
        case done
    }

    init() {
        client.updateCookies()
    }

    func initialization() async -> UserData.Step {
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
        } catch let error as VRCKitError {
            errorOccurred(error)
            return .loggingIn
        } catch {
            unexpectedErrorOccurred()
            return .loggingIn
        }
        // complete
        return .done
    }

    func errorOccurred(_ error: VRCKitError) {
        isPresentedAlert = true
        vrckError = error
    }

    func unexpectedErrorOccurred() {
        isPresentedAlert = true
        vrckError = .unexpectedError
    }

    func logout() {
        user = nil
        client.deleteCookies()
        client = APIClient()
        step = .loggedIn
    }
}
