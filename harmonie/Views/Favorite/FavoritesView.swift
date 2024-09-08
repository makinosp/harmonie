//
//  FavoritesView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct FavoritesView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel
    @State var selected: Selected?

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Group {
                if favoriteVM.segment == .friend {
                    listView
                } else if favoriteVM.segment == .world {
                    listWorldView
                }
            }
            .navigationDestination(item: $selected) { selected in
                UserDetailPresentationView(id: selected.id)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    @Bindable var favoriteVM = favoriteVM
                    Picker("", selection: $favoriteVM.segment) {
                        ForEach(FavoriteViewModel.Segment.allCases) { segment in
                            Text(segment.description).tag(segment)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Favorites")
        } detail: {
            Text("Select a friend")
        }
        .navigationSplitViewStyle(.balanced)
    }

    var listView: some View {
        List {
            ForEach(favoriteVM.favoriteFriendGroups) { group in
                if let friends = favoriteVM.getFavoriteFriends(group.id) {
                    Section(header: Text(group.displayName)) {
                        ForEach(friends) { friend in
                            rowView(friend)
                        }
                    }
                }
            }
        }
        .overlay {
            if favoriteVM.favoriteFriendGroups.isEmpty {
                ContentUnavailableView {
                    Label {
                        Text("No Favorites")
                    } icon: {
                        Constants.Icon.favorite
                    }
                }
            }
        }
    }

    func rowView(_ friend: Friend) -> some View {
        Button {
            selected = Selected(id: friend.id)
        } label: {
            LabeledContent {
                Constants.Icon.forward
            } label: {
                Label {
                    Text(friend.displayName)
                } icon: {
                    ZStack {
                        Circle()
                            .foregroundStyle(friend.status.color)
                            .frame(size: Constants.IconSize.thumbnailOutside)
                        CircleURLImage(
                            imageUrl: friend.imageUrl(.x256),
                            size: Constants.IconSize.thumbnail
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
    }

      var listWorldView: some View {
          List {
              ForEach(groupedWorlds.keys.sorted(), id: \.self) { group in
                  if let worlds = groupedWorlds[group] {
                      Section(header: Text(group)) {
                          ForEach(worlds) { world in
                              rowWorldView(world)
                          }
                      }
                  }
              }
          }
      }

        var groupedWorlds: [String: [World]] {
            let grouped = Dictionary(grouping: favoriteVM.favoriteWorlds, by: { String($0.name.prefix(1)) })
            return grouped
        }

      func rowWorldView(_ world: World) -> some View {
          Button {
              selected = Selected(id: world.id)
          } label: {
              VStack(alignment: .leading) {
                  Text(world.name)
                      .font(.headline)
                  Text(world.description)
                      .font(.subheadline)
                      .foregroundColor(.gray)
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
          }
          .contentShape(Rectangle())
      }
  }
