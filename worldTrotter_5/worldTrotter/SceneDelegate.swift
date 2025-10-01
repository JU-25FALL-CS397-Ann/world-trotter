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

        // Build tabs
        let convertVC = ConversionViewController()
        convertVC.tabBarItem = UITabBarItem(title: "Convert",
                                            image: UIImage(systemName: "thermometer"),
                                            tag: 0)

        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(title: "Map",
                                        image: UIImage(systemName: "map"),
                                        tag: 1)

        let quizVC = QuizViewController()
        quizVC.tabBarItem = UITabBarItem(title: "Quiz",
                                         image: UIImage(systemName: "questionmark.circle"),
                                         tag: 2)

        let tab = UITabBarController()
        tab.viewControllers = [convertVC, mapVC, quizVC]

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tab
        window.makeKeyAndVisible()
        self.window = window
    }
}
