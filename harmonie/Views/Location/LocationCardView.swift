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
    @Environment(AppViewModel.self) private var appVM: AppViewModel
    @Binding var selected: InstanceLocation?
    @State private var instance: Instance?
    @State private var isImageLoaded = false
    let service: any InstanceServiceProtocol
    let location: FriendsLocation
    let frameWidth: CGFloat = 100

    var backGroundColor: Color {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            Color(uiColor: .tertiarySystemGroupedBackground)
        default:
            Color(uiColor: .secondarySystemGroupedBackground)
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(backGroundColor)
            if let instance = instance {
                locationCardContent(instance: instance)
                    .onTapGesture {
                        selected = InstanceLocation(location: location, instance: instance)
                    }
            } else {
                ProgressView()
            }
        }
        .frame(minHeight: 120)
        .task {
            do {
                instance = try await service.fetchInstance(location: location.location)
            } catch {
                appVM.handleError(error)
            }
        }
    }

    func locationCardContent(instance: Instance) -> some View {
        HStack(spacing: 16) {
            locationThumbnail(instance.world.imageUrl(.x512))
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
        .padding()
    }

    func personAmount(_ instance: Instance) -> String {
        [location.friends.count, instance.userCount, instance.capacity]
            .map { $0.description }
            .joined(separator: " / ")
    }

    func friendThumbnail(friend: Friend) -> some View {
        ZStack {
            Circle()
                .foregroundStyle(friend.status.color)
                .frame(size: Constants.IconSize.thumbnailOutside)
            CircleURLImage(
                imageUrl: friend.imageUrl(.x256),
                size: Constants.IconSize.thumbnail
            )
        }
    }

    func locationThumbnail(_ url: URL?) -> some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } else if state.error != nil {
                Constants.Icon.exclamation
            } else {
                EmptyView()
                    .onDisappear {
                        isImageLoaded = true
                    }
            }
        }
        .frame(width: frameWidth, height: frameWidth * 3/4)
        .redacted(reason: isImageLoaded ? .placeholder : [])
    }
}
