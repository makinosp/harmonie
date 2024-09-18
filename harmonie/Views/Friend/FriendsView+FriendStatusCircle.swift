//
//  FriendsView+Friends.swift
//  Harmonie
//
//  Created by xili on 2024/09/18.
//
import SwiftUI
import VRCKit
extension FriendsView {
    func friendStatusCircle(friend: Friend) -> some View {
        Circle()
            .frame(
                width: Constants.IconSize.thumbnailOutside.width * 0.3,
                height: Constants.IconSize.thumbnailOutside.height * 0.3
            )
            .foregroundColor(friend.status.color)
            .overlay(
                Circle()
                    .frame(
                        width: Constants.IconSize.thumbnailOutside.width * 0.15,
                        height: Constants.IconSize.thumbnailOutside.height * 0.15
                    )
                    .foregroundColor(friend.platform.isWebColor)
            )
            .offset(
                x: Constants.IconSize.thumbnailOutside.width * 0.36,
                y: Constants.IconSize.thumbnailOutside.height * 0.36
            )
    }
     var bittenCircle: some ShapeView {
        BittenCircle(biteSize: Constants.IconSize.thumbnailOutside.width * 0.4, offsetRatio: 0.65)
            .fill(style: FillStyle(eoFill: true))
    }
}
