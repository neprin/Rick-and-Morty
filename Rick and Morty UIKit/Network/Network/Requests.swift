//
//  Requests.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/11/22.
//

import UIKit

class CharactersRequest: NetworkRequestProtocol {
    typealias ResponseType = BasicAPIResponse<RickAndMortyCharacter>

    let endpoint: Schema
    let method: HTTPMethod = .GET

    init(page: Int) {
        endpoint = .getCharacters(page: page)
    }
}

class EpisodesRequest: NetworkRequestProtocol {
    typealias ResponseType = BasicAPIResponse<EpisodeResult>

    let endpoint: Schema
    let method: HTTPMethod = .GET

    init(name: String, page: Int) {
        endpoint = .getEpisodes(for: name, page: page)
    }
}
