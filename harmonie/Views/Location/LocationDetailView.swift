//
//  LocationDetailView.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/17.
//

import AsyncSwiftUI
import NukeUI
import VRCKit

struct LocationDetailView: View {
    let instance: Instance

    var body: some View {
        VStack {
            Text("LocationDetailView")
            Text(instance.id)
        }
    }
}
