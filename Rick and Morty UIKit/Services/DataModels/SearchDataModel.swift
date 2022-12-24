//
//  SearchDataModel.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getAllEpisodes = try? newJSONDecoder().decode(GetAllEpisodes.self, from: jsonData)

import Foundation

// MARK: - GetCharacter
struct GetCharacter: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let name: String
    let type: String
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
