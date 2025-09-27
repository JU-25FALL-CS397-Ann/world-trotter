//
//  SceneDelegate.swift
//  worldTrotter
//
//  Created by Ann Ubaka on 9/20/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = ConversionViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
