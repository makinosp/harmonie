//
//  URL+Identifiable.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/23.
//

import Foundation

extension URL: Identifiable {
    public var id: Int { hashValue }
}