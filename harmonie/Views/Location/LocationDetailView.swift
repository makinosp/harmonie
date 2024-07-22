//
//  LocationDetailView.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/17.
//

import AsyncSwiftUI
import NukeUI
import VRCKit

struct LocationDetailView: View {
    let instance: Instance
    let location: FriendsLocation

    var body: some View {
        NavigationStack {
            List {
                Section("World") {
                    imageContainer
                        .listRowInsets(EdgeInsets())
                }
                Section("Friends") {
                    friendList
                }
            }
        }
    }

    @MainActor
    var imageContainer: some View {
        LazyImage(url: URL(string: instance.world.imageUrl)) { state in
            if let image = state.image {
                imageBuilder(image: image)
            } else if state.error != nil {
                Image(systemName: Constants.IconName.exclamation)
                    .frame(maxHeight: 160)
            } else {
                ZStack {
                    Color.clear
                        .frame(height: 160)
                    ProgressView()
                }
            }
        }
        .overlay(alignment: .bottom) { bottomBar }
    }

    @ViewBuilder
    func imageBuilder(image: Image) -> some View {
        let gradient = Gradient(colors: [.black.opacity(0.5), .clear])
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxHeight: 160)
            .clipped()
            .overlay {
                LinearGradient(
                    gradient: gradient,
                    startPoint: .top,
                    endPoint: .center
                )
            }
            .overlay {
                LinearGradient(
                    gradient: gradient,
                    startPoint: .bottom,
                    endPoint: .center
                )
            }
    }

    var bottomBar: some View {
        HStack {
            HStack(alignment: .bottom) {
                Text(instance.world.name)
                    .font(.headline)
                Text(instance.region.rawValue)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .foregroundStyle(Color.white)
    }

    var friendList: some View {
        ForEach(location.friends) { friend in
            HStack {
                ZStack {
                    Circle()
                        .foregroundStyle(friend.status.color)
                        .frame(size: Constants.IconSize.thumbnailOutside)
                    CircleURLImage(
                        imageUrl: friend.userIconUrl,
                        size: Constants.IconSize.thumbnail
                    )
                }
                Text(friend.displayName)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
    }
}
