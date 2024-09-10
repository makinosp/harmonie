//
//  LocationsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import SwiftUIIntrospect
import VRCKit

struct LocationsView: View, FriendServicePresentable, InstanceServicePresentable {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @State private var selected: InstanceLocation?

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            locationList
                .navigationTitle("Locations")
                .navigationDestination(item: $selected) { selected in
                    LocationDetailView(
                        instance: selected.instance,
                        location: selected.location
                    )
                }
        } detail: {
            NavigationStack {
                ContentUnavailableView {
                    Label {
                        Text("Select a location")
                    } icon: {
                        Constants.Icon.location
                    }
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .refreshable {
            do {
                try await friendVM.fetchAllFriends(service: friendService)
            } catch {
                appVM.handleError(error)
            }
        }
        .introspect(.navigationSplitView, on: .iOS(.v17, .v18)) { splitView in
            splitView.maximumPrimaryColumnWidth = .infinity
            splitView.preferredPrimaryColumnWidthFraction = 1 / 2
        }
    }

    private var locationList: some View {
        List(friendVM.friendsLocations) { location in
            if location.isVisible {
                LocationCardView(selected: $selected, location: location)
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
