//
//  HelpView.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/19.
//

import SwiftUI

struct HelpView {
    struct Help {
        let title: String
        let text: String
    }

    let contents: [Help]
}

extension HelpView: View {
    var body: some View {
        EmptyView()
    }
}
