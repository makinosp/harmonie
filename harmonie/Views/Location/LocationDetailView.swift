//
//  LocationDetailView.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/17.
//

import AsyncSwiftUI
import NukeUI
import MemberwiseInit
import VRCKit

@MemberwiseInit
struct LocationDetailView: View {
    @InitWrapper(.internal, type: Binding<SegmentIdSelection?>)
    @Binding private var selection: SegmentIdSelection?
    @Init(.internal) private let instanceLocation: InstanceLocation

    private var location: FriendsLocation { instanceLocation.location }
    private var instance: Instance { instanceLocation.instance }

    private typealias InformationItem = (title: String, value: String)
    private var information: [InformationItem] {
        let platforms = instance.userPlatforms.map(\.description).joined(separator: ", ")
        return [
            (title: String(localized: "Instance Type"), value: instance.typeDescription),
            (title: String(localized: "Friends"), value: location.friends.count.description),
            (title: String(localized: "Users"), value: instance.userCount.description),
            (title: String(localized: "Capacity"), value: instance.capacity.description),
            (title: String(localized: "Region"), value: instance.region.description),
            (title: String(localized: "Platform"), value: platforms)
        ]
    }

    var body: some View {
        List(selection: $selection) {
            Section("World") {
                HStack(spacing: 12) {
                    SquareURLImage(
                        imageUrl: instance.world.imageUrl(.x1024),
                        thumbnailImageUrl: instance.world.imageUrl(.x256)
                    )
                    VStack(alignment: .leading) {
                        Text(instance.world.name)
                            .font(.body)
                            .lineLimit(1)
                        Text(instance.world.description ?? "")
                            .font(.footnote)
                            .foregroundStyle(Color.gray)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    IconSet.forward.icon
                }
                .tag(SegmentIdSelection(worldId: instance.world.id))
            }
            Section("Friends") { friendList }
            Section("Information") { informationList }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(instance.world.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var friendList: ForEach<[Friend], Friend.ID, some View> {
        ForEach(location.friends) { friend in
            NavigationLabel {
                Label {
                    Text(friend.displayName)
                } icon: {
                    UserIcon(user: friend, size: Constants.IconSize.thumbnail)
                }
            }
            .tag(SegmentIdSelection(friendId: friend.id))
        }
    }

    private var informationList: ForEach<[InformationItem], String, some View> {
        ForEach(information, id: \.title) { informationItem in
            LabeledContent {
                Text(informationItem.value)
            } label: {
                Text(informationItem.title)
            }
        }
    }
}
