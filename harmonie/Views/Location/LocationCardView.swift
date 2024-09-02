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
    let service: any InstanceServiceProtocol
    let location: FriendsLocation
    let frameWidth: CGFloat = 120

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
        HStack(alignment: .top) {
            locationThumbnail(instance.world.imageUrl(.x512))
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text(instance.world.name)
                        .font(.body)
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

    func locationThumbnail(_ url: URL?) -> some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: frameWidth)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else if state.error != nil {
                Constants.Icon.exclamation
                    .frame(maxWidth: frameWidth)
            } else {
                ZStack {
                    Color.clear
                        .frame(maxWidth: frameWidth)
                    ProgressView()
                }
            }
        }
    }
}
