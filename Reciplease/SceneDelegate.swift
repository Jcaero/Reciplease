//
//  SceneDelegate.swift
//  Reciplease
//
//  Created by pierrick viret on 21/09/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let home = TabBar()
        self.window?.rootViewController = home
        window?.makeKeyAndVisible()
    }
}
