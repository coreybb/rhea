//
//  SceneDelegate.swift
//  Rhea
//
//  Created by Corey Beebe on 10/12/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupWindow(windowScene: windowScene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}


//  MARK: - Private API

private extension SceneDelegate {
    
    func setupWindow(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        window!.rootViewController = MainController()
        window!.makeKeyAndVisible()
    }
}

