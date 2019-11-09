//
//  Month.swift
//  swift-cal
//
//  Copyright © 2019 Paul Sobolik.
//

import Foundation

struct Month {
    let year: Int
    let month: Int
    let weeks: [[String]]

    init(year: Int, monthNum: Int) {
        if let date = Calendar.current.date(from: DateComponents(year: year, month: monthNum)) {
            self.year = Calendar.current.component(.year, from: date)
            self.month = Calendar.current.component(.month, from: date)
            self.weeks = Month.calcWeeks(date: date)
        } else {
            self.year = 0
            self.month = 0
            self.weeks = []
        }
    }

    private static func calcWeeks(date: Date) -> [[String]] {
        func startNum(date: Date) -> Int {
            1 - Calendar.current.component(.weekday, from: date) + 1
        }

        func endNum(date: Date) -> Int {
            Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
        }

        let startDay = startNum(date: date)
        let endDay = endNum(date: date)
        var weekday = 0
        var week = [String]()
        var weeks: [[String]] = []
        for day in startDay...endDay {
            if weekday == 7 {
                weeks.append(week)
                week = [String]()
                weekday = 0
            }
            week.append(day > 0 && day <= endDay ? String(reflecting: day) : "")
            weekday += 1
        }
        // Handle partial week
        if week.count > 0 {
            while week.count < 7 {
                week.append("")
            }
            weeks.append(week)
        }
        return weeks
    }
}
