//
//  BSKeyboardControls.swift
//  bskeyboardcontrols
//
//  Created by Ivan Milles on 09/02/15.
//  Copyright (c) 2015 Mr Green. All rights reserved.
//

import UIKit

enum BSKeyboardControl: UInt8 {
	case AllZeros = 0b00
	case PreviousNext = 0b01
	case Done = 0b10
	case AllButtons = 0b11		// Needed for pretty weak Swift NSOption support
}

enum BSKeyboardControlsDirection: Int {
	case Previous = 0
	case Next = 1
}

protocol BSKeyboardControlsDelegate {
	func keyboardControls(keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection);
	func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls)
}

class BSKeyboardControls: UIView {
	var toolbar: UIToolbar!
	var doneButton: UIBarButtonItem!
	var previousButton: UIBarButtonItem!
	var nextButton: UIBarButtonItem!
	
	var delegate: BSKeyboardControlsDelegate?
	var visibleControls: BSKeyboardControl = .AllZeros {
		didSet {
			updateToolbar()
		}
	}
	var fields: [UITextField] = [] {		// TODO: Support for UITextView too
		didSet {
			installOnFields()
		}
	}
	
	var activeField: UITextField? {
		didSet {
			activeField?.becomeFirstResponder()
			updatePreviousNextEnabledStates()
		}
	}
	
	var barStyle: UIBarStyle {
		get {return toolbar.barStyle}
		set {toolbar.barStyle = newValue}
	}
	var barTintColor: UIColor? {
		get {return toolbar.barTintColor?}
		set {toolbar.barTintColor = newValue}
	}
	var doneTintColor: UIColor? {
		get {return doneButton.tintColor?}
		set {doneButton.tintColor = newValue}
	}
	var doneTitle: String? {
		get {return doneButton.title}
		set {doneButton.title = newValue}
	}
	
	required convenience init(coder aDecoder: NSCoder) {
		self.init(fields: [])
	}
	
	override convenience init(frame: CGRect) {
		self.init(fields: [])
	}
	
	init(fields: [UITextField]) {
		super.init(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 44.0))
		toolbar = UIToolbar(frame: self.frame)
		barStyle = .Default
		toolbar.autoresizingMask = .FlexibleLeftMargin | .FlexibleRightMargin
		addSubview(toolbar)

		previousButton = UIBarButtonItem(image: UIImage(named: "backbutton"), style: .Plain, target: self, action: "selectPreviousField")
		nextButton = UIBarButtonItem(image: UIImage(named: "nextbutton"), style: .Plain, target: self, action: "selectNextField")
		doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "doneButtonPressed")
		visibleControls = BSKeyboardControl(rawValue: BSKeyboardControl.PreviousNext.rawValue | BSKeyboardControl.Done.rawValue)!
		
		self.fields = fields

		// didSet observers not called from init()
		installOnFields()
		updateToolbar()
	}
	
	func installOnFields() {
		for field in fields {
			field.inputAccessoryView = self
		}
	}
	
	func updateToolbar() {
		toolbar.items = toolbarItems()
	}
	
	func toolbarItems() -> [AnyObject] {
		var outItems = [AnyObject]()

		if visibleControls.rawValue & BSKeyboardControl.PreviousNext.rawValue > 0 {
			outItems.append(previousButton)
			outItems.append(nextButton)
		}
		
		if visibleControls.rawValue & BSKeyboardControl.Done.rawValue > 0 {
			outItems.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
			outItems.append(doneButton)
		}
		
		return outItems
	}
	
	func updatePreviousNextEnabledStates() {
		if let index = find(fields, activeField!) {
			previousButton.enabled = (index > 0)
			nextButton.enabled = (index < fields.count - 1)
		}
	}
	
	func selectPreviousField() {
		if let index = find(fields, activeField!) {
			if index > 0 {
				activeField = fields[index - 1]
				delegate?.keyboardControls(self, selectedField: activeField!, inDirection: .Previous)
			}
		}
	}

	func selectNextField() {
		if let index = find(fields, activeField!) {
			if index < fields.count - 1 {
				activeField = fields[index + 1]
				delegate?.keyboardControls(self, selectedField: activeField!, inDirection: .Next)
			}
		}
	}
	
	func doneButtonPressed() {
		delegate?.keyboardControlsDonePressed(self)
	}
}