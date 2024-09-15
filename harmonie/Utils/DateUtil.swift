//
//  DateUtil.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/11.
//

import Foundation

final class DateUtil {
    func formatRelative(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        let components = Calendar.current.dateComponents(
            [.day, .year, .month, .minute, .second],
            from: Date(),
            to: date
        )
        return formatter.localizedString(from: components)
    }
}
