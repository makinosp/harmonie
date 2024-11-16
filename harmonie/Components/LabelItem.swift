//
//  LabelItem.swift
//  Harmonie
//
//  Created by makinosp on 2024/11/16.
//

import MemberwiseInit
import SwiftUICore

@MemberwiseInit
struct LabelItem {
    @Init(label: "_") let value: String
    @Init let caption: String
    @Init let systemName: String
    @Init(default: Font.body) let fontSize: Font
}

extension LabelItem: Identifiable {
    var id: UUID { UUID() }
}

extension LabelItem {
    init(_ value: String, caption: String, icon: Iconizable, fontSize: Font = .body) {
        self.init(value, caption: caption, systemName: icon.systemName, fontSize: fontSize)
    }
}

@MemberwiseInit
struct LabelItems {
    @Init(label: "_") let items: [LabelItem]
}

extension LabelItems: Identifiable {
    var id: UUID { UUID() }
}

extension LabelItem: View {
    var body: some View {
        VStack {
            VStack(spacing: 2) {
                Image(systemName: systemName)
                Text(caption)
                    .font(.caption)
            }
            .foregroundStyle(Color.accentColor)
            Text(value.description)
                .font(fontSize)
        }
        .frame(maxWidth: .infinity)
    }
}
