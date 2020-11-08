//
//  API+searchHeroes.swift
//  API
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import WallamarvelKit

public extension API {
    func fetchHeroes(page: Range<Int>, completion: @escaping (Result<[Hero], APIError>) -> Void) {
        gateway.request(urlResource: Hero.searchResource(token: nil, page: page, credentials: credentials)) { result in
            completion(result)
        }
    }
    
    func searchHeroes(string: String, page: Range<Int>, completion: @escaping (Result<[Hero], APIError>) -> Void) {
        gateway.request(urlResource: Hero.searchResource(token: string, page: page, credentials: credentials)) { result in
            completion(result)
        }
    }
    
    func fetchHeroeDetail(id: Int, completion: @escaping (Result<Hero, APIError>) -> Void) {
        gateway.request(urlResource: id.heroeDeail(credentials: credentials)) { result in
            completion(result)
        }
    }
}



fileprivate extension Hero {
    static func searchResource(token: String?, page: Range<Int>, credentials: Credentials)-> Resource<[Hero]> {
        let url = URL(string: "v1/public/characters", relativeTo: .base)!
        var parameters: [String: Any] = [:]
        parameters["limit"] = page.count
        parameters["offset"] = page.lowerBound
        parameters["nameStartsWith"] = token
        parameters.merge(credentials.authParams, uniquingKeysWith:  { (_, new) in new })
        return Resource<[Hero]>(url: url, httpMethod: .get, parameters: parameters) { data in
            try? JSONDecoder().decode(EndPointResults<[Hero]>.self, from: data).result
        }
    }
}

fileprivate extension Int {
    func heroeDeail(credentials: Credentials) -> Resource<Hero> {
        let url = URL(string: "v1/public/characters/\(self)", relativeTo: .base)!
        let parameters = credentials.authParams
        return Resource<Hero>(url: url, httpMethod: .get, parameters: parameters) { data in
            try? JSONDecoder().decode(EndPointResults<[Hero]>.self, from: data).result.first
        }
    }
}
