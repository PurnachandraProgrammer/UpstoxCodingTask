import XCTest
import Foundation
@testable import UpstoxCodingTask

class CryptoCoinsListViewModelTest: XCTestCase {
    
    var cryptoCoinViewModel : CryptoCoinsListViewModel!
    fileprivate var cryptoCoinsTestService : MockCryptoCoinsApiListService!
    
    override func setUp() {
        super.setUp()
        
        // Create View model with the help mock API service and PlanetDataService
        self.cryptoCoinViewModel = CryptoCoinsListViewModel(cryptoCoinRepository: MockCryptoDataRepository())
    }
    
    override func tearDown() {
        self.cryptoCoinViewModel = nil
        super.tearDown()
    }
}

// Mock API service, to get the planets from JSON.
// This class is used to fetch the planets from the server as of now.

fileprivate class MockCryptoCoinsApiListService : CryptoCoinListApiResourceService {
    
    func getCryptoCoinsList() async -> ([CryptoCoin]?, (any Error)?) {
        guard let filePath = Bundle(for:CryptoCoinViewControllerTest.self).url(forResource: "CryptoCoinsResponse", withExtension: "json"),
              let data = try? Data(contentsOf: filePath) else {
            return (nil,NSError(domain: "Error", code: 500))
        }
        
        let decoder = JSONDecoder()
        let cryptoCoins: [CryptoCoin]? = try? decoder.decode([CryptoCoin].self, from: data)
        return (cryptoCoins, nil)
    }
}

class MockCryptoDataRepository : CryptoDataRepository {
 
    func fetchCryptoCoinsData() async -> ([CryptoCoin]?, (any Error)?) {

        guard let filePath = Bundle(for:CryptoCoinViewControllerTest.self).url(forResource: "CryptoCoinsResponse", withExtension: "json"),
              let data = try? Data(contentsOf: filePath) else {
            return (nil,NSError(domain: "Error", code: 500))
        }
        
        let decoder = JSONDecoder()
        let cryptoCoins: [CryptoCoin]? = try? decoder.decode([CryptoCoin].self, from: data)
        return (cryptoCoins, nil)

    }
}


