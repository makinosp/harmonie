//
//  LocationsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct LocationsView: View {
    @Environment(AppViewModel.self) var appVM
    @Environment(FriendViewModel.self) var friendVM
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var selectedInstance: InstanceLocation?
    @State private var isSelectedPrivate = false
    @State private var selection: SegmentIdSelection?

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebar
        } content: {
            content
        } detail: {
            detail
        }
        .navigationSplitViewStyle(.balanced)
        .refreshable {
            await friendVM.fetchAllFriends { error in
                appVM.handleError(error)
            }
        }
    }

    private var sidebar: some View {
        List(selection: $selectedInstance) {
            friendLocations
            if !friendVM.isFetchingAllFriends {
                inPrivateInstance
            }
        }
        .environment(\.defaultMinListRowHeight, 80)
        .overlay {
            if friendVM.isContentUnavailable {
                ContentUnavailableView {
                    Label("No Friend Location", systemImage: IconSet.friends.systemName)
                }
            }
        }
        .navigationTitle("Social")
        .setColumn(appVM.screenSize)
    }

    private var content: some View {
        Group {
            if let location = selectedInstance?.location,
               let instance = selectedInstance?.instance {
                LocationDetailView($selection, location: location, instance: instance)
            } else if let instance = selectedInstance, instance.location.location == .private {
                PrivateLocationView($selection, friends: instance.location.friends)
            } else {
                ContentUnavailableView {
                    Label("Select a location", systemImage: IconSet.location.systemName)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .setColumn(appVM.screenSize)
    }

    private var detail: some View {
        Group {
            if let selection = selection {
                Group {
                    switch selection.segment {
                    case .friends:
                        UserDetailPresentationView(selected: selection.selected)
                    case .world:
                        WorldPresentationView(id: selection.selected.id)
                    }
                }
                .id(selection.selected.id)
            } else {
                ContentUnavailableView {
                    Label("Select a friend or world", systemImage: IconSet.info.systemName)
                }
            }
        }
        .safeAreaPadding(.top, 20)
        .background(Color(.systemGroupedBackground))
        .setColumn(appVM.screenSize)
    }

    private var friendLocations: some View {
        Section {
            if friendVM.isFetchingAllFriends {
                ForEach(0...7, id: \.self) { _ in
                    LocationCardView(
                        selected: .constant(nil),
                        location: PreviewData.friendsLocation
                    )
                }
            } else {
                ForEach(friendVM.visibleFriendsLocations) { location in
                    LocationCardView(
                        selected: $selectedInstance,
                        location: location
                    )
                }
            }
        } header: {
            HStack {
                Text("Friend Locations")
                Text(verbatim: "(\(friendVM.visibleFriendsLocations.count))")
                    .redacted(reason: friendVM.isFetchingAllFriends ? .placeholder : [])
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
                                .lineLimit(1)
                            Text(friendVM.friendsInPrivate.count.description)
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        NavigationLabel()
                    }
                    HorizontalProfileImages(friendVM.friendsInPrivate)
                }
                .padding(.top, 4)
            }
            .tag(InstanceLocation(friends: friendVM.friendsInPrivate))
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

private extension View {
    func setColumn(_ screenSize: CGSize) -> some View {
        navigationSplitViewColumnWidth(
            min: screenSize.width * 1 / 3,
            ideal: screenSize.width * 1 / 3,
            max: screenSize.width / 2
        )
    }
}

#Preview {
    PreviewContainer {
        LocationsView()
    }
}
