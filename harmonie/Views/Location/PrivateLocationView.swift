//
//  PrivateLocationView.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/30.
//

import MemberwiseInit
import SwiftUI
import VRCKit

@MemberwiseInit
struct PrivateLocationView: View {
    @InitWrapper(.internal, label: "_", type: Binding<SegmentIdSelection?>)
    @Binding private var selection: SegmentIdSelection?
    @Init(.internal) private let friends: [Friend]

    var body: some View {
        List(selection: $selection) {
            Section("Friends") {
                ForEach(friends) { friend in
                    NavigationLabel {
                        Label {
                            Text(friend.displayName)
                        } icon: {
                            UserIcon(user: friend, size: Constants.IconSize.thumbnail)
                        }
                    }
                    .tag(SegmentIdSelection(friendId: friend.id))
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Private")
        .navigationBarTitleDisplayMode(.inline)
    }
}
