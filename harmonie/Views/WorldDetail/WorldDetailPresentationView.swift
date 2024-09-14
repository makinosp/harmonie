//
//  WorldDetailPresentationView.swift
//  Harmonie
//
//  Created by xili on 2024/09/13.
//

import SwiftUI
import VRCKit

struct WorldDetailPresentationView: View, WorldServicePresentable {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @State var world: World?
    let id: String

    var body: some View {
        if let world = world {
            WorldDetailView(world: world)
                .refreshable {
                    await fetchWorld(id: id)
                }
        } else {
            ProgressScreen()
                .task(id: id) {
                    await fetchWorld(id: id)
                }
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
