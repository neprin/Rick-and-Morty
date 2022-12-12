//
//  GeneralResponse.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/12/22.
//

import Foundation

struct BasicAPIResponse<T: Decodable>: Decodable {
    let pageInfo: PageInfo
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case pageInfo = "info"
        case results = "results"
    }
}
