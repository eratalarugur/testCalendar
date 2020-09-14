//
//  DateInfoView.swift
//  TestCalendar
//
//  Created by Ugur Eratalar on 13.09.2020.
//  Copyright © 2020 Ugur Eratalar. All rights reserved.
//

import Foundation
import UIKit

protocol MonthViewDateSelectionDelegate: class {
	func goToSpecificDate(specificDate: Date)
}

class DateInfoView: UIView {
	
	weak var monthViewDelegate: MonthViewDateSelectionDelegate?
	var lineColor: UIColor?
	var infoDateForView: Date?
	
	lazy var lineView: UIView = {
		let view =  UIView()
		view.backgroundColor = self.lineColor
		return view
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.textColor = .secondaryLabel
		return label
	}()
	
	lazy var dateInfoLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.textColor = .label
		return label
	}()
	
	lazy var seperatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.init(white: 0.7, alpha: 0.5)
		return view
	}()
	
	lazy var dateSelectionButton: UIButton = {
		let btn = UIButton(type: .system)
		btn.backgroundColor = .clear
		btn.addTarget(self, action: #selector(goToSelectedDate), for: .touchUpInside)
		return btn
	}()
	
	@objc func goToSelectedDate() {
		monthViewDelegate?.goToSpecificDate(specificDate: infoDateForView!)
	}
	
	private lazy var formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .gregorian)
		formatter.locale = Locale(identifier: "tr_TR")
		formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
		return formatter
	}()
	
	init(color: UIColor, title: String, infoDateForView: Date) {
		
		super.init(frame: .zero)
		self.lineColor = color
		titleLabel.text = title
		self.infoDateForView = infoDateForView
		dateInfoLabel.text = formatter.string(from: infoDateForView)
		
		addSubview(lineView)
		addSubview(titleLabel)
		addSubview(dateInfoLabel)
		addSubview(seperatorView)
		addSubview(dateSelectionButton)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		lineView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 5, paddingRight: 0, width: 2, height: 0)
		titleLabel.anchor(top: topAnchor, left: lineView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: lineView.frame.size.height / 2)
		dateInfoLabel.anchor(top: titleLabel.bottomAnchor, left: lineView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 0, height: lineView.frame.size.height / 2)
		seperatorView.anchor(top: dateInfoLabel.bottomAnchor, left: lineView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 1)
		dateSelectionButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		self.bringSubviewToFront(dateSelectionButton)
	}
	
}
