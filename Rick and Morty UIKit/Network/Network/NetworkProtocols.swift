//
//  NetworkProtocols.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/11/22.
//

import UIKit

protocol NetworkServiceProtocol: AnyObject {
    var customDecoder: JSONDecoder { get }
    
    func fetch<T: NetworkRequestProtocol>(_ request: T) async throws -> T.ResponseType
}

protocol NetworkRequestProtocol {
    associatedtype ResponseType: Decodable
    
    var endpoint: Schema { get }
    var method: HTTPMethod { get }
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
