//
//  LocationCardView.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/15.
//

import NukeUI
import SwiftUI
import VRCKit

struct LocationCardView: View {
    @Environment(AppViewModel.self) var appVM
    @Binding var selected: InstanceLocation?
    @State private var instance: Instance?
    @State private var isRequesting = true
    @State private var isFailure = false
    let location: FriendsLocation

    var body: some View {
        Group {
            if isFailure {
                EmptyView()
            } else {
                locationCardContent(instance: instance ?? PreviewDataProvider.instance())
            }
        }
        .redacted(reason: isRequesting ? .placeholder : [])
        .task {
            if case let .id(id) = location.location {
                do {
                    defer { withAnimation { isRequesting = false } }
                    let service = appVM.services.instanceService
                    instance = try await service.fetchInstance(location: id)
                } catch {
                    isFailure = true
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
                HorizontalProfileImages(location.friends)
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
