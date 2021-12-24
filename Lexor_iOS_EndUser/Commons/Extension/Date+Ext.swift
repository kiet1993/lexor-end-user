//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow: Date { return Date().dayAfter }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon) ?? Date()
    }

    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon) ?? Date()
    }

    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self) ?? Date()
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }

    static var today: Date {
        return Date()
    }

    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(direction: .next, weekDay: weekday, considerToday: considerToday)
    }

    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(direction: .previous, weekDay: weekday, considerToday: considerToday)
    }

    func get(direction: SearchDirection, weekDay: Weekday, considerToday consider: Bool = false) -> Date {
        let dayName = weekDay.rawValue
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName) ?? 0 + 1
        let calendar = Calendar(identifier: .gregorian)
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex

        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        return date ?? Date()
    }

    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }

    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }

    enum SearchDirection {
        case next
        case previous

        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components) ?? Date()
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? Date()
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth) ?? Date()
    }

    var startOfWeek: Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }

    var endOfWeek: Date? {
        guard let sunday = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                                                       from: self)) else { return nil }
        return Calendar.current.date(byAdding: .day, value: 6, to: sunday)
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}

extension Date {
    
    func toString(withFormat type: DateFormatter.FormatType, dateFormatter: DateFormatter = .withLocalTimeZone()) -> String {
        let dateFormatter: DateFormatter = dateFormatter
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
}
