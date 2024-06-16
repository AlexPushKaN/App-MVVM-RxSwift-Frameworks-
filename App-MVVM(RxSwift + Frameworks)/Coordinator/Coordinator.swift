//
//  Coordinator.swift
//  App-MVVM-RxSwift-Frameworks-.git
//
//  Created by Александр Муклинов on 14.06.2024.
//

import UIKit

final class Coordinator {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func show(scene: Scene) {
        
        switch scene {
        case .splash: setupSplashViewController()
        case .main: setupMainViewController()
        }
    }
    
    private func setupSplashViewController() {
        let splashViewModel = SplashViewModel()
        let splashViewController = SplashViewController(coordinator: self, viewModel: splashViewModel)
        
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
    
    private func setupMainViewController() {
        let mainViewModel = MainViewModel(networkService: NetworkManager())
        let mainViewController = MainViewController(mainViewModel: mainViewModel)
        
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
    }
}
