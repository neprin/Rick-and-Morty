//
//  SearchDataModel.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//

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
