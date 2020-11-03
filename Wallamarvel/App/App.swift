//
//  App.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import SlimGateway
import API

final class App {
    
    unowned var window: UIWindow
    
    lazy var api: API = {
        let credentials = Credentials(publicKey: Bundle.main.publicKey, privateKey: Bundle.main.privateKey)
        let gateway = SlimGateway()
        gateway.debug = ProcessInfo.processInfo.isAPICallsDebugging
        let api = API(gateway: gateway, credentials: credentials)
        return api
    }()
    
    lazy var viewControllerFactory: ViewFactoryController = {
        ViewFactoryController(api: api)
    }()
    
    // MARK: Lifecycle
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: Public
    
    func appDidLaunch() {
        window.rootViewController = viewControllerFactory.makeLanding()
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

fileprivate extension ProcessInfo {
    var isAPICallsDebugging: Bool {
        environment["API_CALLS_DEBUG"] == "enable"
    }
}
