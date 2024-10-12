//
//  LocationCardView.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/15.
//

import NukeUI
import SwiftUI
import VRCKit

struct LocationCardView: View, InstanceServiceRepresentable {
    @Environment(AppViewModel.self) var appVM
    @Binding var selected: InstanceLocation?
    @State private var instance: Instance?
    @State private var isRequesting = true
    let location: FriendsLocation

    var body: some View {
        locationCardContent(instance: instance ?? PreviewDataProvider.generateInstance())
            .redacted(reason: isRequesting ? .placeholder : [])
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
    }

    private func locationCardContent(instance: Instance) -> some View {
        HStack(spacing: 16) {
            SquareURLImage(
                imageUrl: instance.world.imageUrl(.x512),
                thumbnailImageUrl: instance.world.imageUrl(.x256)
            )
            VStack(spacing: .zero) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(instance.world.name)
                            .font(.body)
                            .lineLimit(1)
                        HStack {
                            Text(instance.typeDescription)
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            Text(personAmount(instance))
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    NavigationLabel()
                }
                ScrollView(.horizontal) {
                    LazyHStack(spacing: -8) {
                        ForEach(location.friends) { friend in
                            CircleURLImage(
                                imageUrl: friend.imageUrl(.x256),
                                size: Constants.IconSize.thumbnail
                            )
                        }
                    }
                }
                .onTapGesture {
                    selected = tag(instance)
                }
            }
            .padding(.top, 4)
        }
        .tag(tag(instance))
    }

    private func tag(_ instance: Instance) -> InstanceLocation {
        InstanceLocation(location: location, instance: instance)
    }

    private func personAmount(_ instance: Instance) -> String {
        [location.friends.count, instance.userCount, instance.capacity]
            .map { $0.description }
            .joined(separator: " / ")
    }
}
