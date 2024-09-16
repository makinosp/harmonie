//
//  FriendsView+Sort.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/31.
//

import SwiftUI

extension FriendsView {
    var sortMenu: some View {
        Menu {
            ForEach(FriendViewModel.SortType.allCases) { sortType in
                Button {
                    if friendVM.sortType == sortType {
                        friendVM.sortOrder.toggle()
                    } else {
                        friendVM.sortType = sortType
                        friendVM.sortOrder = .asc
                    }
                    friendVM.applyFilters()
                } label: {
                    Label {
                        Text(sortType.description)
                    } icon: {
                        if friendVM.sortType == sortType {
                            switch friendVM.sortOrder {
                            case .asc: Constants.Icon.up
                            case .desc: Constants.Icon.down
                            }
                        }
                    }
                }
            }
        } label: {
            Constants.Icon.sort
        }
    }
}
