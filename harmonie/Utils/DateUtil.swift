//
//  DateUtil.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/11.
//

import Foundation

class DateUtil {
    static let shared = DateUtil()

    private let yyyyMMddDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }()

    private let HHmmDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()

    func formatToyyyyMMdd(from date: Date) -> String {
        return yyyyMMddDateFormatter.string(from: date)
    }

    func formatToHHmm(from date: Date) -> String {
        return HHmmDateFormatter.string(from: date)
    }
}