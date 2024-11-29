//
//  SceneDelegate.swift
//  UpstoxCodingTask
//
//  Created by Purnachandra on 11/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        // Set default light mode.
        if #available (iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        let navigationController = UINavigationController(rootViewController: CryptoCoinsListViewController())
        navigationController.navigationBar.tintColor = .purple
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }


}

