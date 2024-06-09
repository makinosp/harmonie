//
//  HAProgressView.swift
//  harmonie
//
//  Created by makinosp on 2024/05/24.
//

import SwiftUI

struct HAProgressView: View {
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
            ProgressView()
                .controlSize(.large)
        }
        .ignoresSafeArea()
    }
}
