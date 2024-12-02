//
//  CryptoCoinApiListService.swift
//  UpstoxCodingTask
//
//  Created by purnachandra rao obulasetty on 01/12/2024.
//


import Foundation

final class CryptoCoinApiListService : CryptoCoinListApiResourceService {
    
    func getCryptoCoinsList() async -> ([CryptoCoin]?, (any Error)?) {

        let urlString = ApiResource.cryptoCoinsListResource
        let url = URL(string: urlString)

        guard let url = url else {
            return (nil,NSError(domain: "url is not proper", code: 500))
        }
        
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForRequest = 10
        let urlSession = URLSession(configuration: urlSessionConfiguration)
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


