//
//  Heroe.swift
//  WallamarvelKit
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import Foundation

public struct Heroe {
    public let id: Int
    public let name: String
    public let about: String?
    public let thumbURL: URL?
}

extension Heroe: Decodable {
    struct Thumbnail: Decodable {
        let path: String
        let `extension`: String
    }
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case about = "description"
        case thumbnail
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let about = try container.decode(String?.self, forKey: .about)
        let thumb = try container.decode(Thumbnail.self, forKey: .thumbnail)
        
        self.id = id
        self.name = name
        self.about = about
        self.thumbURL = URL(string: "\(thumb.path).\(thumb.extension)")
    }
}
