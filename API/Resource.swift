//
//  Resource.swift
//  API
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import Foundation

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public struct Resource<T> {
    public var url: URL
    public var httpMethod: RequestMethod
    public var httpHeaders: [String: String]?
    public var parameters: [String: Any]?
    public var timeOut: TimeInterval
    public var decoder: (Data) -> T?
    
    public init(url: URL, httpMethod: RequestMethod = .get, httpHeaders: [String: String]? = nil, parameters: [String: Any]? = nil, timeOut: TimeInterval = 5, decoder: @escaping (Data) -> T?) {
        self.url = url
        self.httpMethod = httpMethod
        self.httpHeaders = httpHeaders
        self.parameters = parameters
        self.timeOut = timeOut
        self.decoder = decoder
    }
}
