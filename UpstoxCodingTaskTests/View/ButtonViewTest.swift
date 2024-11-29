//
//  ButtonViewTest.swift
//  UpstoxCodingTaskTests
//
//  Created by Purnachandra on 29/10/24.
//

import XCTest
@testable import UpstoxCodingTask

class ButtonViewTest: XCTestCase {
    
    // MARK: - Test Initialization
    
    func testInitWithTitleAndImageName() {
        let buttonView = ButtonView(title: "Test Title", imageName: "checkmark-icon", isSelection: true)
        
        XCTAssertNotNil(buttonView.button, "Button should be initialized")
        XCTAssertNotNil(buttonView.imageView, "ImageView should be initialized")
        XCTAssertNotNil(buttonView.stackView, "StackView should be initialized")
        XCTAssertEqual(buttonView.button?.title(for: .normal), "Test Title", "Button title should match the initialized title")
        XCTAssertEqual(buttonView.isButtonSelected, true, "isButtonSelected should be set correctly")
    }
    
    func testInitWithDefaultImageName() {
        let buttonView = ButtonView(title: "Default Image Test")
        
        XCTAssertEqual(buttonView.imageView?.image, UIImage(named: "checkmark-icon") ?? UIImage(systemName: "checkmark-icon"),
                       "Image should default to 'checkmark-icon' or the system image")
    }
    
    // MARK: - Test Button Selection State
    
    func testButtonSelected_whenSelected() {
        let buttonView = ButtonView(title: "Selected Test", isSelection: true)
        
        buttonView.configureButton()
        
        XCTAssertEqual(buttonView.backgroundColor, UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1.0), "Background color should match selected color")
        XCTAssertFalse(buttonView.imageView?.isHidden ?? true, "ImageView should be visible when selected")
    }
    
    func testButtonSelected_whenNotSelected() {
        let buttonView = ButtonView(title: "Not Selected Test", isSelection: false)
        
        buttonView.configureButton()
        
        XCTAssertEqual(buttonView.backgroundColor, UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0), "Background color should match non-selected color")
        XCTAssertTrue(buttonView.imageView?.isHidden ?? false, "ImageView should be hidden when not selected")
    }
    
    // MARK: - Test Button Tap Action
    
    func testChangeViewWithSelectedStatus_togglesSelection() {
        let buttonView = ButtonView(title: "Toggle Test", isSelection: false)
        buttonView.updatedButtonStatus(isButtonSelected: true)
        
        XCTAssertTrue(buttonView.isButtonSelected, "isButtonSelected should toggle to true after tap")
        XCTAssertFalse(buttonView.imageView?.isHidden ?? false, "ImageView should be visible after selection")
        
        buttonView.updatedButtonStatus(isButtonSelected: false)

        XCTAssertFalse(buttonView.isButtonSelected, "isButtonSelected should toggle back to false after another tap")
        XCTAssertTrue(buttonView.imageView?.isHidden ?? true, "ImageView should be hidden after deselection")
    }
    
    // MARK: - Test Gesture Recognizer
    
    func testTapGestureRecognizer() {
        let buttonView = ButtonView(title: "Gesture Test")
        let recognizers = buttonView.gestureRecognizers
        
        XCTAssertNotNil(recognizers, "ButtonView should have gesture recognizers")
        XCTAssertTrue(recognizers?.contains(where: { $0 is UITapGestureRecognizer }) ?? false, "ButtonView should have a UITapGestureRecognizer")
    }
}
