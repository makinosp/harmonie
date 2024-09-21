//
//  DateUtil.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/11.
//

import Foundation

actor DateUtil: Sendable {
    static let shared = DateUtil()
    private let relativeDateTimeFormatter: RelativeDateTimeFormatter
    private let comparedComponents: Set<Calendar.Component>

    private init() {
        relativeDateTimeFormatter = RelativeDateTimeFormatter()
        comparedComponents = [.year, .month, .day, .hour, .minute, .second]
    }

    /// Returns the difference between two dates as `DateComponents`.
    /// - Parameters:
    ///   - from: The starting date. Defaults to the current date.
    ///   - to: The end date to compare against.
    /// - Returns: The `DateComponents` representing the difference between the two dates.
    private func relativeDateComponents(from: Date = Date(), to: Date) -> DateComponents {
        Calendar.current.dateComponents(comparedComponents, from: from, to: to)
    }

    /// Formats a given date as a localized relative time string (e.g., "3 hours ago").
    /// - Parameter date: The date to compare to the current date.
    /// - Returns: A localized string representing the relative time difference
    ///            between the given date and the current date.
    func formatRelative(from date: Date) -> String {
        relativeDateTimeFormatter.localizedString(from: relativeDateComponents(to: date))
    }
}
