//
//  HomeViewController.swift
//  TestCalendar
//
//  Created by Ugur Eratalar on 12.09.2020.
//  Copyright © 2020 Ugur Eratalar. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: BaseViewController {
	
	// MARK: - UI Elements
	let calendarButton: UIButton = {
		
		let btn = UIButton(type: .system)
		btn.setTitle("Show Calendar", for: .normal)
		btn.layer.cornerRadius = 5.0
		btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
		btn.setTitleColor(.white, for: .normal)
		btn.backgroundColor = .systemTeal
		btn.addTarget(self, action: #selector(handleShowCalendarButton), for: .touchUpInside)
		return btn
		
	}()
	
	var currentDate = Date()
	
	@objc func handleShowCalendarButton() {
		let pickDateVC = PickDateViewController(baseDate: currentDate)
		navigationController?.present(pickDateVC, animated: true, completion: nil)
	}
	
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
		navigationController?.isNavigationBarHidden = true
		
		sceneUISetup()
	}
	
	// MARK: - Setup
	private func sceneUISetup() {
		
		view.addSubview(calendarButton)
		calendarButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 75)
		calendarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		calendarButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
	
}
