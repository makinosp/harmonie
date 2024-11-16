//
//  WorldDetailLabelStacks.swift
//  Harmonie
//
//  Created by makinosp on 2024/11/16.
//

import VRCKit

extension World {
    var labelItemStacks: [LabelItems] {[
        LabelItems([
            LabelItem(visits.description, caption: "Visits", icon: IconSet.eye),
            LabelItem(favorites.text, caption: "Favorites", icon: IconSet.favoriteFilled),
            LabelItem(popularity.description, caption: "Popularity", icon: IconSet.heart)
        ]),
        LabelItems([
            LabelItem(capacity.description, caption: "Capacity", icon: IconSet.eye),
            LabelItem(occupants.text, caption: "Public", icon: IconSet.social),
            LabelItem(privateOccupants.text, caption: "Private", icon: IconSet.widebrim)
        ]),
        LabelItems([
            LabelItem(publicationDate.formatted, caption: "Published", icon: IconSet.megaphone, fontSize: .footnote),
            LabelItem(updatedAt.formatted, caption: "Updated", icon: IconSet.upload, fontSize: .footnote)
        ])
    ]}
}

private extension OptionalISO8601Date {
    var formatted: String {
        date?.formatted(date: .numeric, time: .omitted) ?? "Unknown"
    }
}

private extension Optional<Int> {
    private var unwrappedValue: Int { self ?? 0 }
    var text: String { unwrappedValue.description }
}
