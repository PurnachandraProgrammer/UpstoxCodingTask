import Foundation
import UIKit

/// This class is main view model of this applicaiton.
public class CryptoCoinsListViewModel {
    
    private var cryptoCoinRepository:CryptoCoinRepository!
    
    private var cryptoCoinsList: [CryptoCoin] = []
    var filteredCryptoCoinsList: Dynamic<[CryptoCoin]> = Dynamic([])
    
    var apiFetchError:Dynamic<Error?> = Dynamic(nil)
    
    // Depedency injection
    init(cryptoCoinRepository: CryptoCoinRepository!) {
        self.cryptoCoinRepository = cryptoCoinRepository
    }
    
    func fetchCryptoCoinsList() async {
        
        Task {
            
            let (result,error) = await self.cryptoCoinRepository.fetchCryptoCoinsData()
            
            if error != nil {
                
                let error = NSError(domain: "Error fetching data", code: 500)
                self.apiFetchError.value = error
                return
            }
            
            guard let result = result else {
                let error = NSError(domain: "List is empty", code: 500)
                self.apiFetchError.value = error
                return
            }
            
            self.cryptoCoinsList = result
            self.filteredCryptoCoinsList.value = result
            
        }
        return
    }
    
    func getNumberOfCoins() -> Int {
        return filteredCryptoCoinsList.value.count
    }
    
    func getCryptoCoin(index:NSInteger) -> CryptoCoin {
        return filteredCryptoCoinsList.value[index]
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    category:String? = nil) {
        
        filteredCryptoCoinsList.value = cryptoCoinsList.filter { (cryptoCoin: CryptoCoin) -> Bool in
            
            if searchText.isEmpty {
                return true
            }
            return cryptoCoin.name.lowercased().contains(searchText.lowercased()) || cryptoCoin.symbol.lowercased().contains(searchText.lowercased())
        }
        
    }
}


