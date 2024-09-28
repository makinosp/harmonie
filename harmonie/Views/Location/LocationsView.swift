//
//  LocationsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct LocationsView: View, FriendServicePresentable, InstanceServicePresentable {
    @Environment(AppViewModel.self) var appVM
    @Environment(FriendViewModel.self) var friendVM
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var selectedInstance: InstanceLocation?
    @State private var selection: SegmentIdSelection?

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            locationList
                .navigationTitle("Locations")
                .setColumn()
        } content: {
            Group {
                if let selectedInstance = selectedInstance {
                    LocationDetailView(
                        instanceLocation: selectedInstance,
                        selection: $selection
                    )
                } else {
                    ContentUnavailableView {
                        Label {
                            Text("Select a location")
                        } icon: {
                            Constants.Icon.location
                        }
                    }
                }
            }
            .setColumn()
        } detail: {
            Group {
                if let selection = selection {
                    Group {
                        switch selection.segment {
                        case .friend:
                            UserDetailPresentationView(selected: selection.selected)
                        case .world:
                            WorldPresentationView(id: selection.selected.id)
                        }
                    }
                    .id(selection.selected.id)
                }
            }
            .setColumn()
        }
        .navigationSplitViewStyle(.balanced)
        .refreshable {
            do {
                try await friendVM.fetchAllFriends(service: friendService)
            } catch {
                appVM.handleError(error)
            }
        }
    }

    private var locationList: some View {
        List(selection: $selectedInstance) {
            ForEach(friendVM.friendsLocations.filter(\.location.isVisible)) { location in
                LocationCardView(
                    selected: $selectedInstance,
                    location: location
                )
            }
            Section("Private") {
                HStack(spacing: 16) {
                    SquareURLImage(imageUrl: Const.privateWorldImageUrl)
                    VStack(spacing: 4) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Private World")
                                    .font(.body)
                                Text(friendVM.friendsInPrivate.count.description)
                                    .font(.footnote)
                                    .foregroundStyle(Color.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                Constants.Icon.forward
                            }
                        }
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: -8) {
                                ForEach(friendVM.friendsInPrivate) { friend in
                                    CircleURLImage(
                                        imageUrl: friend.imageUrl(.x256),
                                        size: Constants.IconSize.thumbnail
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        .overlay {
            if friendVM.isRequesting {
                ProgressScreen()
            } else if friendVM.friendsLocations.isEmpty {
                ContentUnavailableView {
                    Label {
                        Text("No Friend Location")
                    } icon: {
                        Constants.Icon.location
                    }
                }
            }
        }
    }
}

extension Location {
    var isVisible: Bool {
        switch self {
        case .id: true
        default: false
        }
    }
}

fileprivate extension View {
    func setColumn() -> some View {
        self.navigationSplitViewColumnWidth(
            min: WindowUtil.width * 1 / 3,
            ideal: WindowUtil.width * 1 / 3,
            max: WindowUtil.width / 2
        )
    }
}
