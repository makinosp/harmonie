//
//  KeychainUtil.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/25.
//

import Foundation

actor KeychainUtil: Sendable {
    static let shared = KeychainUtil()
    private init() {}

    func savePassword(_ password: String, for account: String) -> Bool {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier,
              let passwordData = password.data(using: .utf8) else { return false }
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: bundleIdentifier,
            kSecValueData: passwordData
        ] as CFDictionary
        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        return status == errSecSuccess
    }

    func getPassword(for account: String) -> String? {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return nil }
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: bundleIdentifier,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)
        guard status == errSecSuccess, let passwordData = item as? Data else { return nil }
        return String(data: passwordData, encoding: .utf8)
    }

    func deletePassword(for account: String) -> Bool {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return false }
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: bundleIdentifier,
            kSecAttrAccount: account
        ] as CFDictionary
        let status = SecItemDelete(query)
        return status == errSecSuccess
    }
}
