//
//  LocationsView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct LocationsView: View {
    @EnvironmentObject var friendVM: FriendViewModel

    var appVM: AppViewModel {
        friendVM.appVM
    }

    var client: APIClient {
        appVM.client
    }

    var service: any InstanceServiceProtocol {
        appVM.isDemoMode ? InstancePreviewService(client: client) : InstanceService(client: client)
    }

    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVStack {
                    ForEach(friendVM.friendsLocations) { location in
                        if location.isVisible {
                            LocationCardView(
                                service: service,
                                location: location
                            )
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Locations")
        } detail: {
            EmptyView()
        }
    }
}
