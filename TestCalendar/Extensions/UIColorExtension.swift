//
//  UIColorExtension.swift
//  TestCalendar
//
//  Created by Ugur Eratalar on 12.09.2020.
//  Copyright © 2020 Ugur Eratalar. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	
	static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
		return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
	}
	
	class var dueDate: UIColor {
		return .rgb(red: 239, green: 194, blue: 93)
	}
	
	class var selectedDate: UIColor {
		return .rgb(red: 76, green: 134, blue: 187)
	}
	
}
