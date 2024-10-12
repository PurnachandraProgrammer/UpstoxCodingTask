import Foundation

// This class is used to fetch the planets from the server as of now.
final class CryptoCoinsApiListService : CryptoCoinListApiResourceService {
    
    func getCryptoCoinsList() async -> ([CryptoCoin]?, (any Error)?) {

        let jsonURL = URL(string: ApiResource.cryptoCoinsListResource)!
        let urlRequest = URLRequest(url: jsonURL)
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0 // 30 seconds
        config.timeoutIntervalForResource = 60.0 // 60 seconds

        let urlSession = URLSession(configuration: config)
        
        do {
            let (data,urlResponse) = try await urlSession.data(for: urlRequest)
            let response = try JSONDecoder().decode([CryptoCoin].self, from: data)
            return (response,nil)
        }
        catch {
            print("the error is \(error)")
            return (nil,error)
        }
        
    }
}
