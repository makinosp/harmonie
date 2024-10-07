//
//  BundleUtil.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/21.
//

import Foundation

enum BundleUtil {
    private static func getInfo(key: String) -> String {
        Bundle.main.object(forInfoDictionaryKey: key) as? String ?? ""
    }

    static var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }

    static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    static var appBuild: String {
        getInfo(key: "CFBundleVersion")
    }
}
