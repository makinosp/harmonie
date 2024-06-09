//
//  LocationsView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct LocationsView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var friendViewModel: FriendViewModel

    var body: some View {
        ScrollView {
            VStack {
                ForEach(FriendService.friendsGroupedByLocation(friendViewModel.onlineFriends)) { keyValue in
                    HStack {
                        Text(keyValue.location)
                            .lineLimit(1)
                        Text(keyValue.friends.count.description + "人")
                    }
                }
            }
        }
    }
}
