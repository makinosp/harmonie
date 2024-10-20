//
//  Error+isCancelled.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/08.
//

import Foundation

extension Error {
    var isCancelled: Bool {
        (self as NSError?)?.isCancelled ?? false
    }
}

extension NSError {
    /// A Boolean value indicating whether the error represents a cancelled network request.
    var isCancelled: Bool {
        domain == NSURLErrorDomain && code == NSURLErrorCancelled
    }
}
