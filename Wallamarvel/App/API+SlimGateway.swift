//
//  SlimGateway+API.swift
//  Wallamarvel
//
//  Adapters bridging API & Gateway frameworks
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import API
import SlimGateway

extension SlimGateway: Gateway {
    public func request<T>(urlResource: Resource<T>, completion: @escaping (Result<T, APIError>) -> Void) {
        request(urlResource: URLResource(resource: urlResource)) { result in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(APIError(gatewayError: error)))
            }
        }
    }
}

extension URLResource {
    init(resource: Resource<T>) {
        self.init(url: resource.url, httpMethod: HttpMethod(method: resource.httpMethod), httpHeaders: resource.httpHeaders, parameters: resource.parameters, timeOut: resource.timeOut, decoder: resource.decoder)
    }
}

extension HttpMethod {
    init(method: RequestMethod) {
        self.init(rawValue: method.rawValue)!
    }
}

extension APIError {
    init(gatewayError: GatewayError) {
        switch gatewayError {
        case .noConnection:
            self = .noConnection
        case .unauthorized:
            self = .unauthorized
        case .serverError:
            self = .serverError
        case .invalidResource:
            self = .invalidResource
        case .endPointError(let details):
            self = .endPointError(details)
        }
    }
}
