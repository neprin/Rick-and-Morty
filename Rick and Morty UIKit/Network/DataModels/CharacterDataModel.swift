//
//  CharacterDataModel.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/12/22.
//

import Foundation
import UIKit

struct RickAndMortyCharacter: Decodable, Hashable {
    let uuid = UUID()
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: String
    let imageUrl: String
    let created: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case species = "species"
        case gender = "gender"
        case imageUrl = "image"
        case created = "created"
    }
}

// MARK: - CharacterStatus Enum
extension RickAndMortyCharacter {
    enum CharacterStatus: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }
}
