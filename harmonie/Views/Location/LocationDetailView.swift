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

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                imageContainer
//                contentStacks
            }
        }
    }

    var imageContainer: some View {
        LazyImage(url: URL(string: instance.world.imageUrl)) { state in
            if let image = state.image {
                imageBuilder(image: image)
            } else if state.error != nil {
                Image(systemName: "exclamationmark.circle")
                    .frame(maxHeight: 250)
            } else {
                ZStack {
                    Color.clear
                        .frame(height: 250)
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
            .frame(maxHeight: 250)
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
}
