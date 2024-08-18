//
//  LocationsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct InstanceLocation: Hashable, Identifiable {
    var location: FriendsLocation
    var instance: Instance
    var id: Int { hashValue }
}

struct LocationsView: View {
    @EnvironmentObject var friendVM: FriendViewModel
    @State var selected: InstanceLocation?
    let appVM: AppViewModel

    var service: any InstanceServiceProtocol {
        appVM.isDemoMode ? InstancePreviewService(client: appVM.client) : InstanceService(client: appVM.client)
    }

    var backGroundColor: Color {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            Color(UIColor.secondarySystemGroupedBackground)
        default:
            Color(UIColor.systemGroupedBackground)
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
