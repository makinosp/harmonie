//
//  View+sectioning.swift
//  harmonie
//
//  Created by makinosp on 2024/06/05.
//

import SwiftUI

extension View {
    func sectioning() -> some View {
        modifier(SectionModifier())
    }
}
