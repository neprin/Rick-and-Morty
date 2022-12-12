//
//  ApiError.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/11/22.
//

import Foundation

struct APIError: Decodable, Error {
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "error"
    }
}
