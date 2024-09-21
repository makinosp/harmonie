//
//  BundleUtil.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/21.
//

import Foundation

enum BundleUtil {
    static var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }

    static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
