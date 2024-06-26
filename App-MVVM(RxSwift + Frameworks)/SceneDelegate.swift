//
//  SceneDelegate.swift
//  App-MVVM-RxSwift-Frameworks-.git
//
//  Created by Александр Муклинов on 14.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let coordinator = Coordinator(window: window)
        self.coordinator = coordinator
        
        coordinator.show(scene: .main)
    }
}
