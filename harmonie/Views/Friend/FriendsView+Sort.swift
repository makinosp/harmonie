//
//  FriendsView+Sort.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/31.
//

import SwiftUI

extension FriendsView {
    var sortArrowIconName: String {
        switch friendVM.sortOrder {
        case .asc: Constants.IconName.arrowUp
        case .desc: Constants.IconName.arrowDown
        }
    }

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
                } label: {
                    Label {
                        Text(sortType.description)
                    } icon: {
                        if friendVM.sortType == sortType {
                            Image(systemName: sortArrowIconName)
                        }
                    }
                }
            }
        } label: {
            Image(systemName: Constants.IconName.sort)
        }
    }
}
