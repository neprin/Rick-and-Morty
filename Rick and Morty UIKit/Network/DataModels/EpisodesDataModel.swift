//
//  Episodes.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/11/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getAllEpisodes = try? newJSONDecoder().decode(GetAllEpisodes.self, from: jsonData)

import Foundation

// MARK: - Page Info
struct PageInfo: Codable {
    let count: Int // items Count - The length of the response
    let pages: Int // The amount of pages
    let next: String? // Link to the next page (if it exists)
    let prev: String? // Link to the previous page (if it exists)

    enum CodingKeys: String, CodingKey {
        case count = "count"
        case pages = "pages"
        case next = "next"
        case prev = "prev"
    }
}

// MARK: - Episod Result
struct EpisodeResult: Codable, Hashable {
    let uuid = UUID()
    let id: Int
    let name: String
    let airDate: String
    let episode: String // номер эпизода например: S01E03
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case airDate = "air_date"
        case episode = "episode"
        case characters = "characters"
        case url = "url"
        case created = "created"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
