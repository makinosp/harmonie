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
        getInfo(key: "CFBundleDisplayName")
    }

    static var appVersion: String {
        getInfo(key: "CFBundleShortVersionString")
    }

    static var appBuild: String {
        getInfo(key: "CFBundleVersion")
    }
}
