//
//  Item.swift
//  friendplus
//
//  Created by makinosp on 2024/03/03.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
