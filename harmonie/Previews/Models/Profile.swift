//
//  PreviewProfile.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/20.
//

import Foundation
import VRCKit

extension PreviewData {
    enum Profile: String, CaseIterable {
        case emma
        case josh
        case clarke
        case nathalie
        case meihua
        case stella
    }
}

extension PreviewData.Profile {
    var name: String {
        rawValue.capitalized
    }

    static var random: Self? {
        allCases.randomElement()
    }

    static var randomName: String {
        random?.rawValue.capitalized ?? ""
    }

    static var randomImageUrl: URL? {
        random?.imageUrl()
    }
}

extension PreviewData.Profile: ImageUrlRepresentable {
    func imageUrl(_ resolution: ImageResolution = .origin) -> URL? {
        let path: String
        switch self {
        case .emma:
            path = "/00/64/j71jho9d_o.jpeg"
        case .josh:
            path = "/4c/65/8mxWMTxR_o.jpg"
        case .clarke:
            path = "/27/09/ooNrEkFY_o.jpg"
        case .nathalie:
            path = "/46/2a/PjWXRlvt_o.jpg"
        case .meihua:
            path = "/55/ca/a2MRVLCx_o.jpg"
        case .stella:
            path = "/2f/73/4L6Bn9x9_o.jpg"
        }
        return URL(string: PreviewData.imageBaseURL + path)
    }
}
