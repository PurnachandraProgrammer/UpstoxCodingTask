//
//  UtilityTests.swift
//  UpstoxCodingTaskTests
//
//  Created by Purnachandra on 02/12/24.
//

import XCTest
import UIKit
@testable import UpstoxCodingTask

class MockAlertPresenter: AlertPresenter {
    private(set) var presentedAlert: UIAlertController?
    private(set) var wasPresentedAnimated: Bool = false

    func presentAlert(_ alert: UIAlertController, animated: Bool) {
        self.presentedAlert = alert
        self.wasPresentedAnimated = animated
    }
}

final class UtilityTests: XCTestCase {
    
    func testShowAlertWithNSError() {
        
        // Arrange
        let mockPresenter = MockAlertPresenter()
        let error = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
        
        // Act
        Utility.showAlert(for: error, withPresenter: mockPresenter)
        
        // Assert
        XCTAssertNotNil(mockPresenter.presentedAlert)
        XCTAssertEqual(mockPresenter.presentedAlert?.title, "TestError")
        XCTAssertEqual(mockPresenter.presentedAlert?.message, "Something went wrong")
        XCTAssertTrue(mockPresenter.wasPresentedAnimated)
    }

    func testShowAlertWithTitleAndMessage() {
        // Arrange
        let mockPresenter = MockAlertPresenter()
        let title = "Test Title"
        let message = "Test Message"
        
        // Act
        Utility.showAlert(title: title, message: message, withPresenter: mockPresenter)
        
        // Assert
        XCTAssertNotNil(mockPresenter.presentedAlert)
        XCTAssertEqual(mockPresenter.presentedAlert?.title, title)
        XCTAssertEqual(mockPresenter.presentedAlert?.message, message)
        XCTAssertTrue(mockPresenter.wasPresentedAnimated)
    }
}


