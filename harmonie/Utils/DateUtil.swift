//
//  DateUtil.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/11.
//

import Foundation

final class DateUtil {
    static let shared = DateUtil()
    private let relativeDateTimeFormatter: RelativeDateTimeFormatter
    private let comparedComponents: Set<Calendar.Component>

    private init() {
        relativeDateTimeFormatter = RelativeDateTimeFormatter()
        comparedComponents = [.day, .year, .month, .minute, .second]
    }

    private func relativeDateComponents(from: Date = Date(), to: Date) -> DateComponents {
        Calendar.current.dateComponents(comparedComponents, from: from, to: to)
    }

    func formatRelative(from date: Date) -> String {
        relativeDateTimeFormatter.localizedString(from: relativeDateComponents(to: Date()))
    }
}
