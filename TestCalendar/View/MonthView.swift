//
//  MonthView.swift
//  TestCalendar
//
//  Created by Ugur Eratalar on 12.09.2020.
//  Copyright © 2020 Ugur Eratalar. All rights reserved.
//

import Foundation
import UIKit

protocol PickDateDelegate: class {
	func showNextMonth()
	func showPreviousMonth()
	func goToSpecificDate(specificDate: Date)
}

class MonthView: UIView, MonthViewDateSelectionDelegate {

	weak var pickDateDelegate: PickDateDelegate?
	
	private lazy var monthCollectionView: UICollectionView = {
		
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.isScrollEnabled = false
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .systemGroupedBackground
		return collectionView
		
	}()
	
	lazy var monthLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 20)
		label.text = "month"
		label.textColor = .black
		label.textAlignment = .center
		return label
	}()
	
	lazy var dayNamesStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.distribution = .fillEqually
		return stackView
	}()
	
	lazy var previousMonthButton: UIButton = {
		let btn = UIButton()
		btn.setImage(UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
		btn.addTarget(self, action: #selector(previousMonthButtonTapped), for: .touchUpInside)
		return btn
	}()
	
	@objc func previousMonthButtonTapped() {
		pickDateDelegate?.showPreviousMonth()
	}
	
	lazy var nextMonthButton: UIButton = {
		let btn = UIButton()
		btn.setImage(UIImage(systemName: "chevron.right")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
		btn.addTarget(self, action: #selector(nextMonthButtonTapped), for: .touchUpInside)
		return btn
	}()
	
	@objc func nextMonthButtonTapped() {
		pickDateDelegate?.showNextMonth()
	}
	
	lazy var dateInfoStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.distribution = .fillEqually
		stackView.axis = .vertical
		return stackView
	}()
	
	private lazy var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .gregorian)
		formatter.locale = Locale.autoupdatingCurrent
		formatter.setLocalizedDateFormatFromTemplate("MMMM y")
		return formatter
	}()
	
	private lazy var formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .gregorian)
		formatter.locale = Locale(identifier: "tr_TR")
		formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
		return formatter
	}()
	
	var baseDate = Date() {
		didSet {
			monthLabel.text = dateFormatter.string(from: baseDate)
			monthCollectionView.reloadData()
		}
	}
	let dueDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())
	var days = [Day]()
	var numberOfWeeksInBaseDate = 0
	private var selectedDate: Date? {
		didSet {
			selectedDateInfoView.dateInfoLabel.text = formatter.string(from: selectedDate ?? Date())
		}
	}

	private lazy var selectedDateInfoView = DateInfoView(color: UIColor.selectedDate, title: "Selected Date", infoDateForView: Date())
	private lazy var dueDateInfoView = DateInfoView(color: UIColor.dueDate, title: "Due Date", infoDateForView: dueDate!)
	
	@objc func handleGestureRecognizer(gesture: UISwipeGestureRecognizer) {
		if gesture.direction == .right {
			print("right swipe")
			previousMonthButtonTapped()
		} else if gesture.direction == .left {
			print("left swipe")
			nextMonthButtonTapped()
		}
	}
	
	init() {
		super.init(frame: .zero)
		backgroundColor = .systemGroupedBackground
		self.layer.cornerRadius = 20.0
		self.clipsToBounds = true
		
		addSubview(previousMonthButton)
		addSubview(nextMonthButton)
		addSubview(monthLabel)
		addSubview(dayNamesStackView)
		addSubview(monthCollectionView)
		addSubview(dateInfoStackView)
		
		let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleGestureRecognizer(gesture:)))
		rightSwipe.direction = .right
		self.addGestureRecognizer(rightSwipe)
		let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleGestureRecognizer(gesture:)))
		leftSwipe.direction = .left
		self.addGestureRecognizer(leftSwipe)
		
		dateInfoStackView.addArrangedSubview(selectedDateInfoView)
		selectedDateInfoView.monthViewDelegate = self
		dateInfoStackView.addArrangedSubview(dueDateInfoView)
		dueDateInfoView.monthViewDelegate = self
		
		for dayNumber in 1...7 {
			let dayLabel = UILabel()
			dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
			dayLabel.textColor = .secondaryLabel
			dayLabel.textAlignment = .center
			dayLabel.text = dayOfWeekText(dayNumber: dayNumber)
			dayNamesStackView.addArrangedSubview(dayLabel)
		}
		
		setupCollectionView()
	}
	
	private func setupCollectionView() {
		monthCollectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: MonthCollectionViewCell.reuseIdentifier)
		monthCollectionView.delegate = self
		monthCollectionView.dataSource = self
	}
	
	func updateData(baseDate: Date, days: [Day], numberOfWeeksInBaseDate: Int, selectedDate: Date) {
		self.baseDate = baseDate
		self.days = days
		self.selectedDate = selectedDate
		self.numberOfWeeksInBaseDate = numberOfWeeksInBaseDate
		self.updateCollectionView()
	}
	
	func goToSpecificDate(specificDate: Date) {
		pickDateDelegate?.goToSpecificDate(specificDate: specificDate)
	}
	
	func updateCollectionView() {
		monthCollectionView.reloadData()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		previousMonthButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
		nextMonthButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
		monthLabel.anchor(top: topAnchor, left: previousMonthButton.rightAnchor, bottom: nil, right: nextMonthButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
		dayNamesStackView.anchor(top: monthLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
		monthCollectionView.anchor(top: dayNamesStackView.bottomAnchor, left: leftAnchor, bottom: dateInfoStackView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
		dateInfoStackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 120)
		self.addShadow()
	}

}

extension MonthView: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return days.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCollectionViewCell.reuseIdentifier, for: indexPath) as? MonthCollectionViewCell else { return UICollectionViewCell() }
		var day = days[indexPath.item]
		if let dateSelected = selectedDate {
			day.isSelected = Calendar.current.isDate(day.date, inSameDayAs: dateSelected)
		}
		cell.dueDate = dueDate
		cell.day = day
		return cell
	}
}

extension MonthView: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let day = days[indexPath.item]
		let lastSelectedDate = selectedDate
		
		if !day.isWithinDisplayedMonth {
			if lastSelectedDate?.compare(day.date) == ComparisonResult.orderedAscending {
				nextMonthButtonTapped()
			} else {
				previousMonthButtonTapped()
			}
		}
		selectedDate = day.date
		updateCollectionView()

	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = Int(collectionView.frame.width / 7)
		let height = Int(collectionView.frame.size.height / CGFloat(numberOfWeeksInBaseDate))
		return CGSize(width: width, height: height)
	}
}

extension MonthView {
	
	private func dayOfWeekText(dayNumber: Int) -> String {
		
		switch dayNumber {
		case 1:
			return "SU"
		case 2:
			return "MO"
		case 3:
			return "TU"
		case 4:
			return "WE"
		case 5:
			return "TH"
		case 6:
			return "FR"
		case 7:
			return "SA"
		default:
			return ""
		}
		
	}
}
