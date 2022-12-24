//
//  GeneralResponse.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/12/22.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getAllEpisodes = try? newJSONDecoder().decode(GetAllEpisodes.self, from: jsonData)

import Foundation

struct BasicAPIResponse<T: Decodable>: Decodable {
    let pageInfo: PageInfo
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case pageInfo = "info"
        case results = "results"
    }
}
