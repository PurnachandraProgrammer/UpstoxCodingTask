import Foundation
import UIKit

/// This class is main view model of this applicaiton.
public class CryptoCoinsListViewModel {
    
    var cryptoCoinsList: Dynamic<[CryptoCoin]>?
    private var cryptoCoinListService:CryptoCoinListBaseService!
    let reachability: Reachability = Reachability()

    // Depedency injection
    init(cryptoCoinListService: CryptoCoinListBaseService!) {
        self.cryptoCoinListService = cryptoCoinListService
    }
    
    func fetchCryptoCoinsList() async -> ([CryptoCoin]?,NSError?) {
        
        if self.reachability.isConnectedToNetwork() {
            
            let (result,error) = await self.cryptoCoinListService.getCryptoCoinsList()
            
            if error != nil {
                return (nil, NSError(domain: "Some thing went wrong", code: 500))
            }
            
            guard let result = result else {
                return (nil, NSError(domain: "List is empty", code: 500))
            }
            
            self.cryptoCoinsList = Dynamic(result)
            return (result,nil)

        }
        return (nil, NSError(domain: "Network is not rechable", code: 500))
    }
    
    func getNumberOfCoins() -> Int {
        
        if let cryptoCoinsList = self.cryptoCoinsList?.value {
            return cryptoCoinsList.count
        }
        
        return 0
    }
    
    func getCryptoCoin(index:NSInteger) -> CryptoCoin {
        return self.cryptoCoinsList!.value[index]
    }
}

