//
//  NavigationController.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 05/11/2020.
//

import UIKit

final class NavigationController: UINavigationController {
    
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
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func transition(from fromViewController: UIViewController, to toViewController: UIViewController, duration: TimeInterval, options: UIView.AnimationOptions = [], animations: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        print(fromViewController)
        print(toViewController)
    }
}
