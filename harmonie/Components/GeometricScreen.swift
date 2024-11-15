//
//  GeometricScreen.swift
//  Harmonie
//
//  Created by makinosp on 2024/11/15.
//

import SwiftUICore

struct GeometricScreen<Content>: View where Content: View {
    private let content: () -> Content
    private let action: (_ geometry: GeometryProxy) -> Void

    init(
        @ViewBuilder content: @escaping () -> Content,
        action: @escaping (_ geometry: GeometryProxy) -> Void
    ) {
        self.content = content
        self.action = action
    }

    var body: some View {
        GeometryReader { geometry in
            content()
                .onChange(of: geometry) {
                    action(geometry)
                }
                .onAppear {
                    action(geometry)
                }
        }
    }
}
