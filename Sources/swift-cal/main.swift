//
//  main.swift
//  swift-cal
//
//  Copyright © 2019 Paul Sobolik. 
//

import Foundation
import SPMUtility

let arguments = Array(CommandLine.arguments.dropFirst())

let parser = ArgumentParser(usage: "<options>", overview: "Print a calendar")

let fastYearOption = parser.add(option: "-Y", kind: Bool.self, usage: "Print a calendar for the current year. Ignore other arguments except width.")
let extraOption = parser.add(option: "--extra", shortName: "-x", kind: Int.self, usage: "Print number of months before and after base. Default: 0")
let fast3Option = parser.add(option: "-3", kind: Bool.self, usage: "Print previous/current/next months. Same as --extra 3")
let beforeOption = parser.add(option: "--before", shortName: "-b", kind: Int.self, usage: "Print number of months before base. Default: 0")
let afterOption = parser.add(option: "--after", shortName: "-a", kind: Int.self, usage: "Print number of months after base. Default: 0")
let widthOption = parser.add(option: "--width", shortName: "-w", kind: Int.self, usage: "Print number of months per line. Default: 3")
let monthOption = parser.add(option: "--month", shortName: "-m", kind: Int.self, usage: "The base month (1-12) to print. Default: current month")
let yearOption = parser.add(option: "--year", shortName: "-y", kind: Int.self, usage: "The base year to print. Default: current year")

do {
    let parsedArgument = try parser.parse(arguments)
        
    var extra: Int = 0
    var before: Int = 0
    var after: Int = 0
    var monthCount = 1
    var month: Int
    let today = Date()
    let year: Int = parsedArgument.get(yearOption) ?? Calendar.current.component(.year, from: today)

    let width: Int = parsedArgument.get(widthOption) ?? 3

    if (parsedArgument.get(fastYearOption) ?? false) {
        month = 1
        monthCount = 12
    } else {
        month = parsedArgument.get(monthOption) ?? Calendar.current.component(.month, from: today)

        if (parsedArgument.get(fast3Option) ?? false) {
            extra = 1
        } else {
            extra = parsedArgument.get(extraOption) ?? 0
        }
        if (extra != 0) {
            before = extra
            after = extra
        } else {
            if (before == 0) {
                before = parsedArgument.get(beforeOption) ?? 0
            }
            if (after == 0) {
                after = parsedArgument.get(afterOption) ?? 0
            }
        }
        monthCount += before
        monthCount += after
    }

    let now = Calendar.current.date(from: DateComponents(year: year, month: month)) ?? today
    
    let firstDate = Calendar.current.date(byAdding: .month, value: -before, to: now) ?? now
    let firstMonth = Calendar.current.component(.month, from: firstDate)
    let firstYear = Calendar.current.component(.year, from: firstDate)
    
    let months = Months.buildMonthArray(year: firstYear, firstMonth: firstMonth, monthCount: monthCount)
    Months.printMonthArray(months: months, monthsPerLine: width)
} catch let error as ArgumentParserError {
    print(error.description)
} catch let error {
    print(error.localizedDescription)
}
