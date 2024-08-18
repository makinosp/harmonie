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
    @EnvironmentObject private var appVM: AppViewModel
    @Binding var selected: InstanceLocation?
    @State private var instance: Instance?
    let service: any InstanceServiceProtocol
    let location: FriendsLocation
    let frameWidth: CGFloat = 120

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color(UIColor.tertiarySystemGroupedBackground))
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
            VStack(alignment: .leading) {
                Text(instance.world.name)
                    .font(.body)
                HStack {
                    Text(instance.typeDescription)
                        .font(.footnote)
                        .foregroundStyle(Color.gray)
                    Spacer()
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
                                    imageUrl: friend.thumbnailUrl,
                                    size: Constants.IconSize.thumbnail
                                )
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            locationThumbnail(instance.world.imageUrl)
                .padding()
        }
    }

    func personAmount(_ instance: Instance) -> String {
        [
            location.friends.count.description,
            instance.userCount.description,
            instance.capacity.description
        ].joined(separator: " / ")
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
                Image(systemName: Constants.IconName.exclamation)
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
