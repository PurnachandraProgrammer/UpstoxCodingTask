import Foundation

// This class is used to fetch the planets from the server as of now.

/*
final class CryptoCoinApiListService : CryptoCoinListApiResourceService {
    
    func getCryptoCoinsList() async -> ([CryptoCoin]?, (any Error)?) {
        
        let path = Bundle.main.path(forResource: "CryptoCoinsResponse", ofType: "json")
        let urlPath = URL(fileURLWithPath: path!)
        
        guard let data = try? Data(contentsOf: urlPath) else {
            return (nil,NSError(domain: "Error", code: 500))
        }
        
        let decoder = JSONDecoder()
        let cryptoCoins: [CryptoCoin]? = try? decoder.decode([CryptoCoin].self, from: data)
        return (cryptoCoins, nil)
    }
}
*/

final class CryptoCoinApiListService : CryptoCoinListApiResourceService {
    
    func getCryptoCoinsList() async -> ([CryptoCoin]?, (any Error)?) {

        let urlString = ApiResource.cryptoCoinsListResource
        let url = URL(string: urlString)

        guard let url = url else {
            return (nil,NSError(domain: "url is not proper", code: 500))
        }
        
        let urlSession = URLSession.shared
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data,_) = try await urlSession.data(for: urlRequest)
            let cryptoCoinList = try JSONDecoder().decode([CryptoCoin].self, from: data)
            return (cryptoCoinList,nil)
        }
        
        catch {
            return (nil,error)
        }
    }
}


