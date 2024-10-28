import XCTest
@testable import UpstoxCodingTask

class CryptoCoinViewControllerTest:XCTestCase {
    
    var sut: CryptoCoinsListViewController!
    var cellID: String!
    var cell: CryptoCoinDetailsTableViewCell!
    
    override func setUpWithError() throws {
        
        sut = CryptoCoinsListViewController()
        sut.loadView()
        cellID = "CryptoCoinCellIdentifier"
        cell = (sut.cryptoCoinsListTableView.dequeueReusableCell(withIdentifier: cellID) as! CryptoCoinDetailsTableViewCell)
    }

    override func tearDownWithError() throws {
        sut = nil
        cell = nil
        cellID = nil
    }

    func test_PlanetsListViewController_WhenCreated_HasTableViewProperty() throws {
        let tableView = try XCTUnwrap(sut.cryptoCoinsListTableView, "TableView is not created")
        XCTAssertNotNil(tableView, "TableView is not created")
    }
    
    func test_PlanetsListViewController_WhenCreated_RegisterCustomTableViewCell() {
        
        sut.loadView()
        XCTAssertNotNil(cell,"TableView doesn't have a cell with CryptoCoinDetailsTableViewCell")
        XCTAssertEqual(cell.reuseIdentifier, cellID, "TableView doesn't have a cell with CryptoCoinDetailsTableViewCell")
    }
    
    func test_CryptoListViewController_WhenCellCreated_CheckTestCoinNameText() throws {
        
        let testCoinName = "Test Coin"
        let testCoinSymbol = ""
        
        cell.configure(coinObject: CryptoCoin(name:testCoinName, symbol: testCoinSymbol))
        XCTAssertEqual(cell.coinNameLabel.text,testCoinName)
    }

    func test_CryptoListViewController_WhenCellCreated_CheckTestCoin() throws {
        
        let testTokenName = "Test Token"
        let testTokenSymbol = "Test Token Symbol"
        let isNew = false
        let isActive = false
        let type: CryptoType = .token
        
        let cryptoObject = CryptoCoin(name: testTokenName, symbol: testTokenSymbol, isNew: isNew, isActive: isActive, type: type)
        
        cell.configure(coinObject:cryptoObject)
        XCTAssertEqual(cell.coinNameLabel.text,testTokenName)
        XCTAssertEqual(cell.coinTypeLabel.text,testTokenSymbol)

    }
    
    
    func test_PlanetsListViewController_WhenCellCreated_ShouldCreateProperties() {
        // Check the not nil value of planetName
        XCTAssertNotNil(cell.coinNameLabel)
    }
    
    func test_PlanetsListViewController_WhenCreated_ShouldBindToTheViewModel() {
        // Check the not nil value of planetViewModel
        XCTAssertNotNil(sut.cryptoCoinsListViewModel)
    }

}

