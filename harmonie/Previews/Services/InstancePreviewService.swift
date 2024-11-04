//
//  InstancePreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/09.
//

import MemberwiseInit
import VRCKit

@MemberwiseInit
final actor InstancePreviewService: APIService, InstanceServiceProtocol {
    let client: APIClient

    func fetchInstance(location: String) async throws -> Instance {
        PreviewData.instanceMap[location] ?? PreviewData.instance
    }

    func fetchInstance(worldId: String, instanceId: String) async throws -> Instance {
        PreviewData.instanceMap["\(worldId):\(instanceId)"] ?? PreviewData.instance
    }
}
