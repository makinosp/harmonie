//
//  HASection.swift
//  harmonie
//
//  Created by makinosp on 2024/06/05.
//

import SwiftUI

struct HASection<Content>: View where Content: View {
    var content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .sectioning()
    }
}
