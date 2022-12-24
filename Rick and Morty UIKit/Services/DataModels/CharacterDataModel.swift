//
//  CharacterDataModel.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/12/22.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getAllEpisodes = try? newJSONDecoder().decode(GetAllEpisodes.self, from: jsonData)

import Foundation

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

// MARK: - CharacterStatus
extension RickAndMortyCharacter {
    enum CharacterStatus: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }
}
