//
//  App.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import SlimGateway
import API

final class App {
    
    // MARK: Injected
    
    unowned var window: UIWindow
    
    // MARK: Components
    
    lazy var api: API = {
        let gateway = SlimGateway()
        gateway.debug = ProcessInfo.processInfo.isAPICallsDebugging
        let credentials = Credentials.apiCredentials
        return API(gateway: gateway, credentials: credentials)
    }()
    
    lazy var viewControllerFactory: ViewControllerFactory = {
        ViewControllerFactory(api: api)
    }()
    
    // MARK: Lifecycle
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: Public
    
    func appDidLaunch() {
        let landingVC = viewControllerFactory.makeHeroesController()
        let landingNC = NavigationController(rootViewController: landingVC)
        landingNC.customTransitions.append(ScreenTransition.detailPush)
        landingNC.customTransitions.append(ScreenTransition.detailPop)
        window.rootViewController = landingNC
    }
}



fileprivate extension Credentials {
    static var apiCredentials: Credentials {
        Credentials(publicKey: Bundle.main.publicKey, privateKey: Bundle.main.privateKey)
    }
}

fileprivate extension Bundle {
    var publicKey: String {
        infoDictionary?["APIMarvelPublicKey"] as! String
    }
    
    var privateKey: String {
        infoDictionary?["APIMarvelPrivateKey"] as! String
    }
}
