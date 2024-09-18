//
//  LocationsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct LocationsView: View, FriendServicePresentable, InstanceServicePresentable {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @State private var selected: InstanceLocation?

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            locationList
                .navigationTitle("Locations")
                .navigationSplitViewColumnWidth(
                    min: 300,
                    ideal: WindowUtil.width / 2,
                    max: WindowUtil.width / 2
                )
        } detail: {
            if let selected = selected {
                LocationDetailView(instanceLocation: selected)
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
        List(friendVM.friendsLocations, selection: $selected) { location in
            if location.isVisible {
                LocationCardView(selected: $selected, location: location).tag(location)
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
