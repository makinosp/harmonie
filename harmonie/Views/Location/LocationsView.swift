//
//  LocationsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import SwiftUIIntrospect
import VRCKit

struct InstanceLocation: Hashable, Identifiable {
    var location: FriendsLocation
    var instance: Instance
    var id: Int { hashValue }
}

struct LocationsView: View {
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @State var selected: InstanceLocation?
    let appVM: AppViewModel

    var service: any InstanceServiceProtocol {
        appVM.isDemoMode ? InstancePreviewService(client: appVM.client) : InstanceService(client: appVM.client)
    }

    var backGroundColor: Color {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            Color(uiColor: .secondarySystemGroupedBackground)
        default:
            Color(uiColor: .systemGroupedBackground)
        }
    }

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            locationList
                .background(backGroundColor)
                .navigationTitle("Locations")
                .navigationDestination(item: $selected) { selected in
                    LocationDetailView(
                        instance: selected.instance,
                        location: selected.location
                    )
                }
        } detail: {
            NavigationStack {
                Text("Select a location")
            }
        }
        .navigationSplitViewStyle(.balanced)
        .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 8 : .zero)
        .refreshable {
            do {
                try await friendVM.fetchAllFriends()
            } catch {
                appVM.handleError(error)
            }
        }
        .introspect(.navigationSplitView, on: .iOS(.v17, .v18)) { splitView in
            splitView.maximumPrimaryColumnWidth = .infinity
            splitView.preferredPrimaryColumnWidthFraction = 1 / 2
        }
    }

    var locationList: some View {
        ScrollView {
            LazyVStack {
                ForEach(friendVM.friendsLocations) { location in
                    if location.isVisible {
                        locatoinItem(location)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }

    func locatoinItem(_ location: FriendsLocation) -> some View {
        LocationCardView(selected: $selected, service: service, location: location)
    }
}
