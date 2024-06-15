//
//  LocationCardView.swift
//  harmonie
//
//  Created by makinosp on 2024/06/15.
//

import NukeUI
import SwiftUI
import VRCKit

struct LocationCardView: View {
    @EnvironmentObject var userData: UserData
    @State var instance: Instance?
    let location: FriendsLocation
    let frameWidth: CGFloat = 120
    let iconSize = CGSize(width: 24, height: 24)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color(UIColor.secondarySystemGroupedBackground))
            if let instance = instance {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(instance.world.name)
                            .font(.body)
                        HStack {
                            Text(instance.type.rawValue)
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                            Spacer()
                            Text(personAmount(instance))
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                        }
                        ScrollView(.horizontal) {
                            HStack(spacing: 4) {
                                ForEach(location.friends) { friend in
                                    CircleURLImage(
                                        imageUrl: friend.userIconUrl,
                                        size: iconSize
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    locationThumbnail(URL(string: instance.world.imageUrl))
                        .padding()
                }
            } else { ProgressView() }
        }
        .frame(minHeight: 120)
        .task {
            do {
                instance = try await InstanceService.fetchInstance(
                    userData.client,
                    location: location.location
                )
            } catch {
                print(error)
            }
        }
    }

    func personAmount(_ instance: Instance) -> String {
        "\(location.friends.count.description) / \(instance.capacity.description)"
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
                Image(systemName: "exclamationmark.circle")
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
