//
//  HAProgressView.swift
//  Harmonie
//
//  Created by makinosp on 2024/05/24.
//

import SwiftUI

struct ProgressScreen: View {
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            ProgressView()
                .controlSize(.large)
        }
        .ignoresSafeArea(.container)
    }
}
