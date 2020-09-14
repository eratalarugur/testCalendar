//
//  MonthDataManager.swift
//  TestCalendar
//
//  Created by Ugur Eratalar on 12.09.2020.
//  Copyright © 2020 Ugur Eratalar. All rights reserved.
//

import Foundation

class MonthDataManager {
	
	let calendar = Calendar(identifier: .gregorian)
	
	private var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "d"
		return formatter
	}()
	
	
	func monthData(date: Date, baseDate: Date) throws -> MonthData {
		
		guard let totalNumberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
			let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
			else {
				throw DateError.dateGeneration
		}
		
		let firstDayWeekDay = calendar.component(.weekday, from: firstDayOfMonth)
		
		return MonthData(totalNumberOfDays: totalNumberOfDaysInMonth, firstDay: firstDayOfMonth, firstDayWeekday: firstDayWeekDay)
	}
	
	func generateDaysInMonth(date: Date, baseDate: Date, selectedDate: Date) -> [Day] {
		
		guard let data = try? monthData(date: date, baseDate: baseDate) else { fatalError("month data is not generated")}
		
		let totalNumberOfDaysInMonth = data.totalNumberOfDays
		let initialRowOffset = data.firstDayWeekday
		let firstDayOfMonth = data.firstDay
		
		var days: [Day] = (1..<(totalNumberOfDaysInMonth + initialRowOffset)).map { day in
			
			let isInCurrentMonth = day >= initialRowOffset
			let dayOffset = isInCurrentMonth ? (day - initialRowOffset) : -(initialRowOffset - day)
			return generateDay(dayOffset: dayOffset, baseDate: firstDayOfMonth, isInCurrentMonth: isInCurrentMonth, selectedDate: selectedDate)
			
		}
		days += generateStartOfNextMonth(firstDayOfDisplayedMonth: firstDayOfMonth, selectedDate: selectedDate)
		return days
	}
	
	func generateDay(dayOffset: Int, baseDate: Date, isInCurrentMonth: Bool, selectedDate: Date) -> Day {
		
		let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
		return Day(date: date, number: dateFormatter.string(from: date), isSelected: calendar.isDate(date, inSameDayAs: selectedDate), isWithinDisplayedMonth: isInCurrentMonth, isWeekend: calendar.isDateInWeekend(date))
		
	}
	
	func generateStartOfNextMonth(firstDayOfDisplayedMonth: Date, selectedDate: Date) -> [Day] {
		
		guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfDisplayedMonth) else { return [] }
		
		let additonalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
		guard additonalDays > 0 else { return [] }
		let days: [Day] = (1...additonalDays).map {
			generateDay(dayOffset: $0, baseDate: lastDayInMonth, isInCurrentMonth: false, selectedDate: selectedDate)
		}
		return days
	}
}
