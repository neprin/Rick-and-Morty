//
//  Requests.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/11/22.
//

import Foundation
import UIKit

class CharactersRequest: NetworkRequestProtocol {
    typealias ResponseType = GeneralAPIResponse<RickAndMortyCharacter>

    let endpoint: Endpoint
    let method: HTTPMethod = .GET

    init(page: Int) {
        endpoint = .getCharacters(page: page)
    }
}

class EpisodesRequest: NetworkRequestProtocol {
    typealias ResponseType = GeneralAPIResponse<Episode>

    let endpoint: Endpoint
    let method: HTTPMethod = .GET

    init(name: String, page: Int) {
        endpoint = .getEpisodes(for: name, page: page)
    }
}
