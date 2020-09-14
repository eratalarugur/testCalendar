//
//  MonthCollectionViewCell.swift
//  TestCalendar
//
//  Created by Ugur Eratalar on 12.09.2020.
//  Copyright © 2020 Ugur Eratalar. All rights reserved.
//

import Foundation
import UIKit

class MonthCollectionViewCell: UICollectionViewCell {
	
	static let reuseIdentifier = String(describing: MonthCollectionViewCell.self)
	
	private lazy var selectedDateBackgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.selectedDate
		view.layer.cornerRadius = 15
		view.clipsToBounds = true
		return view
	}()
	
	private lazy var dateNumberLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
		label.textColor = .black
		return label
	}()
	var dueDate: Date?
	var day: Day? {
		didSet {
			guard let day = day else { return }
			dateNumberLabel.text = day.number
			updateSelectionStatus()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.addSubview(selectedDateBackgroundView)
		contentView.addSubview(dateNumberLabel)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		selectedDateBackgroundView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
		selectedDateBackgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		selectedDateBackgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		dateNumberLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		
		layoutSubviews()
	}
}

private extension MonthCollectionViewCell {
	
	func updateSelectionStatus() {
		
		guard let day = day else { return }
			
		if day.isSelected {
			applySelectedCellStyle()
			if dueDate!.compare(day.date) == ComparisonResult.orderedAscending {
				selectedDateBackgroundView.backgroundColor = .systemPink
			}
		} else {
			applyDefaultCellStyle(isInCurrentMonth: day.isWithinDisplayedMonth, isWeekend: day.isWeekend)
			if Calendar.current.isDate(day.date, inSameDayAs: dueDate!) {
				selectedDateBackgroundView.isHidden = false
				selectedDateBackgroundView.backgroundColor = UIColor.dueDate
			}
		}
		
	}
	
	func applySelectedCellStyle() {
		dateNumberLabel.textColor = .white
		selectedDateBackgroundView.isHidden = false
	}
	
	func applyDefaultCellStyle(isInCurrentMonth: Bool, isWeekend: Bool) {
		dateNumberLabel.textColor = (isInCurrentMonth && !isWeekend) ? .black : .secondaryLabel
		selectedDateBackgroundView.isHidden = true
		
	}
	
}
