//
//  WorldPresentationView.swift
//  Harmonie
//
//  Created by xili on 2024/09/13.
//

import SwiftUI
import VRCKit

struct WorldPresentationView: View, WorldServiceRepresentable {
    @Environment(AppViewModel.self) var appVM
    @State var world: World?
    let id: String

    var body: some View {
        if let world = world {
            WorldView(world: world)
                .refreshable {
                    await fetchWorld(id: id)
                }
        } else {
            ProgressScreen()
                .task(id: id) {
                    await fetchWorld(id: id)
                }
                .navigationTitle("Loading...")
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func fetchWorld(id: String) async {
        do {
            world = try await worldService.fetchWorld(worldId: id)
        } catch {
            appVM.handleError(error)
        }
    }
}
