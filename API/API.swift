//
//  API.swift
//  API
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import Foundation
import CryptoSwift

public protocol Gateway {
    func request<T>(urlResource: Resource<T>, completion: @escaping (Result<T, APIError>) -> Void)
}

public struct Credentials {
    public let publicKey: String
    public let privateKey: String
    
    public init(publicKey: String, privateKey: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
}

public final class API {
    
    // MARK: Injected
    
    public let gateway: Gateway
    public let credentials: Credentials
    
    // MARK: Lifecycle
    
    public init(gateway: Gateway, credentials: Credentials) {
        self.gateway = gateway
        self.credentials = credentials
    }
}


extension Credentials {
    var authParams: [String: Any] {
        let timeStamp = Date().timeIntervalSince1970.description
        var params = [String: Any]()
        params["apikey"] = publicKey
        params["ts"] = timeStamp.description
        params["hash"] = (timeStamp + privateKey + publicKey).md5()
        return params
    }
}

extension URL {
    static var base: URL {
        URL(string: "https://gateway.marvel.com:443")!
    }
}
