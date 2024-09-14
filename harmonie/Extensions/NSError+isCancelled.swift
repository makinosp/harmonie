//
//  NSError+isCancelled.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/08.
//

import Foundation

extension NSError {
    /// A Boolean value indicating whether the error represents a cancelled network request.
    var isCancelled: Bool {
        domain == NSURLErrorDomain && code == NSURLErrorCancelled
    }
}
