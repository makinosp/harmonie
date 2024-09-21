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
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var selectedInstance: InstanceLocation?
    @State private var selectedUser: Selected?

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
                        selectedUser: $selectedUser
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
                if let selectedUser = selectedUser {
                    UserDetailPresentationView(selected: selectedUser)
                        .id(selectedUser)
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
        List(friendVM.friendsLocations, selection: $selectedInstance) { location in
            if location.isVisible {
                LocationCardView(
                    selected: $selectedInstance,
                    location: location
                )
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

fileprivate extension View {
    func setColumn() -> some View {
        self.navigationSplitViewColumnWidth(
            min: WindowUtil.width * 1 / 3,
            ideal: WindowUtil.width * 1 / 3,
            max: WindowUtil.width / 2
        )
    }
}
