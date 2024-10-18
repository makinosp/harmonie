//
//  Icon.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

import MemberwiseInit
import SwiftUI

@MemberwiseInit
struct Icon: Iconizable, Hashable {
    @Init(label: "_") let systemName: String
}
