import Foundation
import UIKit

struct FilterModel {
    
    var isActiveCoin: Bool = false
    var isInActiveCoin: Bool = false
    var isOnlyTokens: Bool = false
    var isOnlyCoins: Bool = false
    var isNewCoins: Bool = false
}

/// This class is main view model of this applicaiton.
public class CryptoCoinsListViewModel {
    
    private var cryptoCoinRepository:CryptoDataRepository!
    private var cryptoCoinsList: [CryptoCoin] = []
    var filteredCryptoCoinsList: Dynamic<[CryptoCoin]> = Dynamic([])
    var apiFetchError:Dynamic<Error?> = Dynamic(nil)

    var filterModel = FilterModel()
    
    // Depedency injection
    init(cryptoCoinRepository: CryptoDataRepository) {
        self.cryptoCoinRepository = cryptoCoinRepository
    }
    
    func updateSearchFilters() {
        
        self.filteredCryptoCoinsList.value = self.cryptoCoinsList
        
        if filterModel.isNewCoins {
            
            self.filteredCryptoCoinsList.value = self.filteredCryptoCoinsList.value.filter({ cryptoCoin in
                return cryptoCoin.isNew
            })
        }
        
        if filterModel.isActiveCoin {
            
            self.filteredCryptoCoinsList.value = self.filteredCryptoCoinsList.value.filter({ cryptoCoin in
                return cryptoCoin.isActive
            })
        }
        
        if filterModel.isOnlyCoins {
            
            self.filteredCryptoCoinsList.value = self.filteredCryptoCoinsList.value.filter({ cryptoCoin in
                return cryptoCoin.type == .coin
            })
        }

        if filterModel.isOnlyTokens {
            
            self.filteredCryptoCoinsList.value = self.filteredCryptoCoinsList.value.filter({ cryptoCoin in
                return cryptoCoin.type == .token
            })
        }

        if filterModel.isInActiveCoin {
            
            self.filteredCryptoCoinsList.value = self.filteredCryptoCoinsList.value.filter({ cryptoCoin in
                return cryptoCoin.isActive == false
            })
        }
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
        self.updateSearchFilters()
        filteredCryptoCoinsList.value = filteredCryptoCoinsList.value.filter { (cryptoCoin: CryptoCoin) -> Bool in
            
            if searchText.isEmpty {
                return true
            }
            return cryptoCoin.name.lowercased().contains(searchText.lowercased()) || cryptoCoin.symbol.lowercased().contains(searchText.lowercased())
        }
        
    }
}


