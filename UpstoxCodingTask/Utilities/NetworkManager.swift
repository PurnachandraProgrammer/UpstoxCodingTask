//
//  NetworkManager.swift
//  UpstoxCodingTask
//
//  Created by Purnachandra on 25/10/24.
//

class NetworkManager {
    
    let reachability: Reachability!

    init() {
        self.reachability = Reachability()
    }
    
    func isConnectedToInternet() -> Bool {
        return reachability.isConnectedToNetwork()
    }
}
