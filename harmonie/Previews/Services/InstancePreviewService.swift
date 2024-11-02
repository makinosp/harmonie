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
        switch location {
        case PreviewDataProvider.instance1.id:
            PreviewDataProvider.instance1
        case PreviewDataProvider.instance2.id:
            PreviewDataProvider.instance2
        default:
            PreviewDataProvider.instance1
        }
    }

    func fetchInstance(worldId: String, instanceId: String) async throws -> Instance {
        switch instanceId {
        case PreviewDataProvider.instance1.instanceId:
            PreviewDataProvider.instance1
        case PreviewDataProvider.instance2.instanceId:
            PreviewDataProvider.instance2
        default:
            PreviewDataProvider.instance1
        }
    }
}
