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
        case PreviewData.instance1.id:
            PreviewData.instance1
        case PreviewData.instance2.id:
            PreviewData.instance2
        default:
            PreviewData.instance1
        }
    }

    func fetchInstance(worldId: String, instanceId: String) async throws -> Instance {
        switch instanceId {
        case PreviewData.instance1.instanceId:
            PreviewData.instance1
        case PreviewData.instance2.instanceId:
            PreviewData.instance2
        default:
            PreviewData.instance1
        }
    }
}
