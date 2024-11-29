//
//  CryptoSearchFilterViewControllerTest.swift
//  UpstoxCodingTaskTests
//
//  Created by Purnachandra on 29/10/24.
//

import XCTest
@testable import UpstoxCodingTask

class CryptoSearchFilterViewControllerTests: XCTestCase {

    var viewController: CryptoSearchFilterViewController!
    var viewModelMock: CryptoCoinsListViewModelMock!
    var cryptoCoinsListViewModel: CryptoCoinsListViewModel!

    override func setUp() {
        super.setUp()
        viewModelMock = CryptoCoinsListViewModelMock(cryptoCoinRepository: MockCryptoDataRepository())
        viewController = CryptoSearchFilterViewController()
        viewController.cryptoCoinsListViewModel = viewModelMock
        viewController.loadViewIfNeeded()
    }

    // MARK: - Test Initialization and View Setup

    func testViewDidLoad_setsUpView() {
        viewController.viewDidLoad()
        
        XCTAssertEqual(viewController.view.backgroundColor, .clear, "Background color should be clear")
        XCTAssertNotNil(viewController.containerViewBottomConstraint, "Bottom constraint should be initialized")
        XCTAssertNotNil(viewController.containerViewHeightConstraint, "Height constraint should be initialized")
    }

    func testSetUpView_buttonSelections() {
        viewController.setUpView()
        
        XCTAssertEqual(viewController.activeCoinsButtonView.isButtonSelected, viewModelMock.filterModel.isActiveCoin, "Active coins button selection should match filter model")
        XCTAssertEqual(viewController.inActiveCoinsButtonView.isButtonSelected, viewModelMock.filterModel.isInActiveCoin, "Inactive coins button selection should match filter model")
        XCTAssertEqual(viewController.onlyTokensButtonView.isButtonSelected, viewModelMock.filterModel.isOnlyTokens, "Only tokens button selection should match filter model")
        XCTAssertEqual(viewController.onlyCoinsButtonView.isButtonSelected, viewModelMock.filterModel.isOnlyCoins, "Only coins button selection should match filter model")
        XCTAssertEqual(viewController.newCoinsButtonView.isButtonSelected, viewModelMock.filterModel.isNewCoins, "New coins button selection should match filter model")
    }

    // MARK: - Test Button Selections and Filter Update

    func testAnimateDismissView_updatesFilterModel() {
        // Simulate button selection changes
        viewController.activeCoinsButtonView.isButtonSelected = true
        viewController.inActiveCoinsButtonView.isButtonSelected = false
        viewController.onlyTokensButtonView.isButtonSelected = true
        viewController.onlyCoinsButtonView.isButtonSelected = false
        viewController.newCoinsButtonView.isButtonSelected = true
        
        viewController.animateDismissView()
        
        XCTAssertTrue(viewModelMock.filterModel.isActiveCoin, "Filter model's active coin status should be updated")
        XCTAssertFalse(viewModelMock.filterModel.isInActiveCoin, "Filter model's inactive coin status should be updated")
        XCTAssertTrue(viewModelMock.filterModel.isOnlyTokens, "Filter model's only tokens status should be updated")
        XCTAssertFalse(viewModelMock.filterModel.isOnlyCoins, "Filter model's only coins status should be updated")
        XCTAssertTrue(viewModelMock.filterModel.isNewCoins, "Filter model's new coins status should be updated")
    }

    func testHandleCloseAction_triggersDismissAnimation() {
        viewController.handleCloseAction()
        
        XCTAssertEqual(viewController.dimmedView.alpha, 0, "Dimmed view alpha should be zero after close action")
        XCTAssertEqual(viewController.containerViewBottomConstraint?.constant, viewController.defaultHeight, "Container view bottom constraint should be reset to default height after close action")
    }

    // MARK: - Test Animations

    func testAnimateContainerHeight_updatesHeightConstraint() {
        let newHeight: CGFloat = 400
        viewController.animateContainerHeight(newHeight)
        
        XCTAssertEqual(viewController.containerViewHeightConstraint?.constant, newHeight, "Container height constraint should update to new height")
        XCTAssertEqual(viewController.currentContainerHeight, newHeight, "Current container height should match updated height")
    }

    func testAnimatePresentContainer_updatesBottomConstraint() {
        viewController.animatePresentContainer()
        
        XCTAssertEqual(viewController.containerViewBottomConstraint?.constant, 0, "Container bottom constraint should be zero when presented")
    }
}

// Mock classes to assist with testing
class CryptoCoinsListViewModelMock: CryptoCoinsListViewModel {

}

