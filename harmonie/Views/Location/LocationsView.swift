//
//  LocationsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct LocationsView: View, FriendServiceRepresentable, InstanceServiceRepresentable {
    @Environment(AppViewModel.self) var appVM
    @Environment(FriendViewModel.self) var friendVM
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var selectedInstance: InstanceLocation?
    @State private var selection: SegmentIdSelection?

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            locationList
                .navigationTitle("Social")
                .setColumn()
        } content: {
            Group {
                if let selectedInstance = selectedInstance {
                    LocationDetailView(
                        selection: $selection,
                        instanceLocation: selectedInstance
                    )
                } else {
                    ContentUnavailableView {
                        Label("Select a location", systemImage: IconSet.location.systemName)
                    }
                }
            }
            .setColumn()
        } detail: {
            Group {
                if let selection = selection {
                    Group {
                        switch selection.segment {
                        case .friends:
                            UserDetailPresentationView(selected: selection.selected)
                        case .world:
                            WorldPresentationView(id: selection.selected.id)
                        default:
                            EmptyView()
                        }
                    }
                    .id(selection.selected.id)
                } else {
                    ContentUnavailableView {
                        Label("Select a friend or world", systemImage: IconSet.info.systemName)
                    }
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
            friendLocations
            inPrivateInstance
        }
        .overlay {
            if friendVM.isRequesting {
                ProgressScreen()
            } else if friendVM.friendsLocations.isEmpty {
                ContentUnavailableView {
                    Label("No Friend Location", systemImage: IconSet.friends.systemName)
                }
            }
        }
    }

    @ViewBuilder private var friendLocations: some View {
        let friendsLocations = friendVM.friendsLocations.filter(\.location.isVisible)
        Section {
            ForEach(friendsLocations) { location in
                LocationCardView(
                    selected: $selectedInstance,
                    location: location
                )
            }
        } header: {
            HStack {
                Text("Friend Locations")
                Text("(\(friendsLocations.count.description))")
            }
        }
    }

    private var inPrivateInstance: some View {
        Section("Private") {
            HStack(spacing: 16) {
                SquareURLImage(imageUrl: Const.privateWorldImageUrl)
                VStack(spacing: .zero) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Private Instances")
                                .font(.body)
                            Text(friendVM.friendsInPrivate.count.description)
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        NavigationLabel()
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
            .padding(.top, 4)
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
