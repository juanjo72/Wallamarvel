//
//  Transition.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 06/11/2020.
//

import UIKit

protocol ImageTransitionController where Self: UIViewController {
    var transitionImageView: UIImageView? { get }
}

struct ScreenTransition {
    var from: UIViewController.Type
    var to: UIViewController.Type
    var type: UINavigationController.Operation
    var transition: UIViewControllerAnimatedTransitioning
}

extension ScreenTransition {
    static var detailPush: ScreenTransition {
        ScreenTransition(from: HeroesController.self, to: HeroeDetailViewController.self, type: .push, transition: ImageTransition(duration: 0.3))
    }
    
    static var detailPop: ScreenTransition {
        ScreenTransition(from: HeroeDetailViewController.self, to: HeroesController.self, type: .pop, transition: ImageTransition(duration: 0.2))
    }
}
