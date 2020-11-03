//
//  EndPointResults.swift
//  API
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import Foundation

struct EndPointResults<T>: Decodable where T: Decodable {
    let result: T
    private enum CodingKeys: String, CodingKey {
        case data
        case results
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        let entity = try results.decode(T.self, forKey: .results)
        self.result = entity
    }
}
