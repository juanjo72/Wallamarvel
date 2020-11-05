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
        let credentials = Credentials(publicKey: Bundle.main.publicKey, privateKey: Bundle.main.privateKey)
        let gateway = SlimGateway()
        gateway.debug = ProcessInfo.processInfo.isAPICallsDebugging
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
        window.rootViewController = landingNC
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

extension ProcessInfo {
    var isAPICallsDebugging: Bool {
        environment["API_CALLS_DEBUG"] == "enable"
    }
    
    var isMemoryDeallocDebugging: Bool {
        environment["MEMORY_DEALLOC_DEBUG"] == "enable"
    }
}
