//
//  SplashViewModel.swift
//  App-MVVM-RxSwift-Frameworks-.git
//
//  Created by Александр Муклинов on 14.06.2024.
//

import UIKit
import RxSwift

final class SplashViewModel {

    var goToMain = PublishSubject<Void>()
    
    func show(mask: CAShapeLayer, view: UIView) {
    }
}
