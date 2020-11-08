//
//  NavigationController.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 05/11/2020.
//

import UIKit

final class NavigationController: UINavigationController {
    
    var customTransitions = [ScreenTransition]()
    
    // MARK: Lifecycle
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    public override var childForStatusBarStyle: UIViewController? {
         topViewController
    }
    
    // MARK: Configure
    
    private func configure() {
        self.delegate = self
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let customBarVC = viewController as? ControllerWithCustomBar {
            navigationController.navigationBar.standardAppearance = customBarVC.navigationBarStyle.appereance
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customTransitions.first { $0.from === type(of: fromVC) && $0.to === type(of: toVC) && $0.type == operation }?.transition
    }
}
