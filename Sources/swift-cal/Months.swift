//
//  Months.swift
//  swift-cal
//
//  Copyright © 2019 Paul Sobolik.
//

import Foundation

class Months {
    static func buildMonthArray(year: Int, firstMonth: Int, monthCount: Int) -> [Month] {
        var result = [Month]()
        for monthNum in firstMonth..<firstMonth + monthCount {
            result.append(Month(year: year, monthNum: monthNum))
        }
        return result
    }

    static func printMonthArray(months: [Month], monthsPerLine: Int) {
        func countWeeks(_ months: ArraySlice<Month>) -> Int {
            months.reduce(0, { weekCount, month in max(weekCount, month.weeks.count) })
        }

        func formatItems(items: [Any], itemWidth: Int) -> String {
            func formatItem(item: Any, width: Int) -> String {
                let str = String(describing: item)
                let pad = str.count < width ? String(repeating: " ", count: width - str.count) : ""
                return "\(pad)\(str) "
            }

            return items.map({ item in formatItem(item: item, width: itemWidth) }).joined()
        }

        func formatMonthHeaders(_ months: ArraySlice<Month>, monthWidth: Int, dayWidth: Int) -> String {
            func formatMonthHeader(_ month: Month, monthWidth: Int, dayWidth: Int) -> String {
                let header = "\(Calendar.current.monthSymbols[month.month - 1]) \(month.year)"
                let width = header.count
                let left = (monthWidth - width - dayWidth) / 2
                let right = monthWidth - left - width
                return String(repeating: " ", count: left) + header + String(repeating: " ", count: right)
            }

            return months.map({ month in formatMonthHeader(month, monthWidth: monthWidth, dayWidth: dayWidth) }).joined()
        }

        func formatWeekHeaders(_ months: ArraySlice<Month>, spacer: String, width: Int) -> String {
            months.map({ _ in formatItems(items: Calendar.current.veryShortStandaloneWeekdaySymbols, itemWidth: width) + spacer }).joined()
        }

        let padding = 2
        let dayWidth = padding + 1
        let monthWidth = (dayWidth * 8) - 1
        let endOfWeek = String(repeating: " ", count: padding)
        let blankWeek = String(repeating: " ", count: monthWidth)

        var monthIndex = 0
        while monthIndex < months.count {
            let monthsAcross = monthIndex + monthsPerLine <= months.count ? monthsPerLine : months.count - monthIndex
            let row = months[monthIndex..<monthIndex + monthsAcross]
            monthIndex += monthsAcross

            let weekCount = countWeeks(row)
            print(formatMonthHeaders(row, monthWidth: monthWidth, dayWidth: dayWidth))
            print(formatWeekHeaders(row, spacer: endOfWeek, width: padding))

            for weekIndex in 0..<weekCount {
                row.forEach { month in
                    if (weekIndex < month.weeks.count) {
                        let week = month.weeks[weekIndex]
                        print(formatItems(items: week, itemWidth: padding), terminator: "")
                        print(endOfWeek, terminator: "")
                    } else {
                        print(blankWeek, terminator: "")
                    }
                }
                print("")
            }
            print("")
        }
    }
}
