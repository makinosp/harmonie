//
//  AppViewModel+PreviewInitializer.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/20.
//

extension AppViewModel {
    /// Initialize as preview mode
    /// - Parameter isPreviewMode
    convenience init(isPreviewMode: Bool) {
        self.init()
        services = APIServiceUtil(isPreviewMode: true, client: client)
        user = PreviewDataProvider.shared.previewUser
    }
}
