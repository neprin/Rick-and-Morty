//
//  Schema.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/12/22.
//

import UIKit

struct Schema {
    var path: String
    var parameter: [URLQueryItem] = []
}

// MARK: - Base URL
extension Schema {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        components.path = "/" + path
        components.queryItems = parameter
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        return url
    }
}

// MARK: - Adding Schema
extension Schema {
    
    static func getCharacters(page: Int) -> Self {
        Schema(
            path: "api/character/",
            parameter: [
                URLQueryItem(name: "page", value: String(page))
            ]
        )}
    
    static func getEpisodes(for name: String, page: Int) -> Self {
        Schema(
            path: "api/episode/",
            parameter: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "name", value: name)
            ]
        )}
    

}
