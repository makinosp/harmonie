//
//  LocationCardView.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/15.
//

import NukeUI
import SwiftUI
import VRCKit

struct LocationCardView: View, InstanceServicePresentable {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Binding var selected: InstanceLocation?
    @State private var instance: Instance?
    @State private var isRequesting = true
    let location: FriendsLocation

    var body: some View {
        if isRequesting {
            locationCardContent(instance: PreviewDataProvider.generateInstance())
                .redacted(reason: .placeholder)
                .task {
                    if case let .id(id) = location.location {
                        do {
                            defer { withAnimation { isRequesting = false } }
                            instance = try await instanceService.fetchInstance(location: id)
                        } catch {
                            appVM.handleError(error)
                        }
                    }
                }
        } else if let instance = instance {
            locationCardContent(instance: instance)
                .onTapGesture {
                    selected = InstanceLocation(location: location, instance: instance)
                }
        }
    }

    private func locationCardContent(instance: Instance) -> some View {
        HStack(spacing: 16) {
            SquareURLImage(
                imageUrl: instance.world.imageUrl(.x512),
                thumbnailImageUrl: instance.world.imageUrl(.x256)
            )
            HStack {
                VStack(alignment: .leading) {
                    Text(instance.world.name)
                        .font(.body)
                        .lineLimit(1)
                    HStack {
                        Text(instance.typeDescription)
                            .font(.footnote)
                            .foregroundStyle(Color.gray)
                        Text(personAmount(instance))
                            .font(.footnote)
                            .foregroundStyle(Color.gray)
                    }
                    ScrollView(.horizontal) {
                        HStack(spacing: -8) {
                            ForEach(location.friends) { friend in
                                friendThumbnail(friend: friend)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Constants.Icon.forward
            }
        }
    }

    private func personAmount(_ instance: Instance) -> String {
        [location.friends.count, instance.userCount, instance.capacity]
            .map { $0.description }
            .joined(separator: " / ")
    }

    private func friendThumbnail(friend: Friend) -> some View {
        ZStack {
            CircleURLImage(
                imageUrl: friend.imageUrl(.x256),
                size: Constants.IconSize.thumbnail
                )
            .mask(BittenCircle().fill(style: FillStyle(eoFill: true)))
            FriendStatusCircle(
                statusColor: friend.status.color,
                platformColor: friend.platform.isWebColor
            )
        }
    }
}
