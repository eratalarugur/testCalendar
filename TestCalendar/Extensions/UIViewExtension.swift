//
//  UIViewExtension.swift
//  TestCalendar
//
//  Created by Ugur Eratalar on 12.09.2020.
//  Copyright © 2020 Ugur Eratalar. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
		
		translatesAutoresizingMaskIntoConstraints = false
		
		if let top = top {
			self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
		}
		
		if let left = left {
			self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
		}
		
		if let bottom = bottom {
			self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
		}
		
		if let right = right {
			self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
		}
		
		if width != 0 {
			widthAnchor.constraint(equalToConstant: width).isActive = true
		}
		
		if height != 0 {
			heightAnchor.constraint(equalToConstant: height).isActive = true
		}
	}
	
	func addShadow() {
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 1
		self.layer.shadowOffset = .zero
		self.layer.shadowRadius = 10
		self.layer.shouldRasterize = true
	}
	
}
