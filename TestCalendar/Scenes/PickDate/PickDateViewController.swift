//
//  PickDateViewController.swift
//  TestCalendar
//
//  Created by Ugur Eratalar on 12.09.2020.
//  Copyright © 2020 Ugur Eratalar. All rights reserved.
//

import Foundation
import UIKit

class PickDateViewController: BaseViewController, PickDateDelegate {
	
	private lazy var calendarMonthView = MonthView()

	// MARK: - Properties
	let monthDataManager = MonthDataManager()
	private var selectedDate: Date?
	private lazy var days = monthDataManager.generateDaysInMonth(date: self.baseDate, baseDate: self.baseDate, selectedDate: self.selectedDate ?? Date())
	private var numberOfWeeksInBaseDate = 0
	private var baseDate: Date {
		didSet {
			days = monthDataManager.generateDaysInMonth(date: baseDate, baseDate: baseDate, selectedDate: selectedDate ?? Date())
		    numberOfWeeksInBaseDate = calendar.range(of: .weekOfMonth, in: .month, for: self.baseDate)?.count ?? 0
			calendarMonthView.updateData(baseDate: baseDate, days: days, numberOfWeeksInBaseDate: numberOfWeeksInBaseDate, selectedDate: selectedDate ?? Date())
		}
	}
	private var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "d"
		return formatter
	}()
		
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		
		view.backgroundColor = .systemGroupedBackground
		calendarMonthView.pickDateDelegate = self
		view.addSubview(calendarMonthView)
		calendarMonthView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 400)
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		calendarMonthView.updateCollectionView()
	}

	init(baseDate: Date) {
		self.baseDate = baseDate
		super.init(nibName: nil, bundle: nil)
		
		numberOfWeeksInBaseDate = calendar.range(of: .weekOfMonth, in: .month, for: self.baseDate)?.count ?? 0
		calendarMonthView.updateData(baseDate: baseDate, days: days, numberOfWeeksInBaseDate: numberOfWeeksInBaseDate, selectedDate: selectedDate ?? Date())

		modalPresentationStyle = .overCurrentContext
		modalTransitionStyle = .crossDissolve
		definesPresentationContext = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func showNextMonth() {
		self.baseDate = self.calendar.date(byAdding: .month, value: 1, to: self.baseDate) ?? self.baseDate
	}
	
	func showPreviousMonth() {
		self.baseDate = self.calendar.date(byAdding: .month, value: -1, to: self.baseDate) ?? self.baseDate
	}
	
	func goToSpecificDate(specificDate: Date) {
		self.baseDate = specificDate
	}
	
}
