//
//  LocationsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct LocationsView: View {
    @EnvironmentObject var friendVM: FriendViewModel
    let appVM: AppViewModel

    var service: any InstanceServiceProtocol {
        appVM.isDemoMode ? InstancePreviewService(client: appVM.client) : InstanceService(client: appVM.client)
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
