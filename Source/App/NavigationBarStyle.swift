//
//  NavigationBarStyle.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 05/11/2020.
//

import UIKit

protocol ControllerWithCustomBar where Self: UIViewController {
    var navigationBarStyle: NavigationBarStyle { get }
}

enum NavigationBarStyle {
    case opaque
    case transparent
}

extension NavigationBarStyle {
    var appereance: UINavigationBarAppearance {
        let barAppereance = UINavigationBarAppearance()
        switch self {
        case .opaque:
            barAppereance.configureWithDefaultBackground()
        case .transparent:
            barAppereance.configureWithTransparentBackground()
        }
        return barAppereance
    }
}
