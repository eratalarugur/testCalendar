//
//  BaseViewController.swift
//  TestCalendar
//
//  Created by Ugur Eratalar on 12.09.2020.
//  Copyright © 2020 Ugur Eratalar. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
	
	// MARK: - Properties
	let calendar = Calendar(identifier: .gregorian)
	
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
}
