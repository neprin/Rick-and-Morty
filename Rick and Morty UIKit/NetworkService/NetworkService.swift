//
//  NetworkService.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//

import Foundation
import UIKit

//class NetworkService {
//
//    func viewDidLoad() {
//        viewDidLoad()
//        
////            // 1) Получаем API
////            let apiRM = "https://rickandmortyapi.com/api/character"
////            // 2) Создаение URL
////            guard let apiURL = URL(string: apiRM) else { return }
////            // 3) Инициализировать сессию
////            let session = URLSession(configuration: .default)
////            // 4) Создать запрос dataTask
////            let task = session.dataTask(with: apiURL) { (data, response, error) in
////                // 5) Обработать полученные данные
////                guard let data = data, error == nil else { return }
////                DispatchQueue.main.async {
////                    // data = .jpeg
////                   // self..image = UIImage(data: data)
////                }
////            }
////            // Запустить запрос
////            task.resume()
//    }
//}

struct PageInfo: Decodable {
    let itemCount: Int
    let pageCount: Int
    let nextPageURL: String?
    let previousPageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case itemCount = "count"
        case pageCount = "pages"
        case nextPageURL = "next"
        case previousPageURL = "prev"
    }
}

struct GeneralAPIResponse<T: Decodable>: Decodable {
    let pageInfo: PageInfo
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case pageInfo = "info"
        case results = "results"
    }
}

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

// MARK: - Base URL
extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        components.path = "/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        return url
    }
}

// MARK: - Endpoints
extension Endpoint {
    
    static func getEpisodes(for name: String, page: Int) -> Self {
        Endpoint(
            path: "api/episode/",
            queryItems: [URLQueryItem(name: "page", value: String(page)),
                         URLQueryItem(name: "name", value: name)]
        )
    }
    static func getCharacters(page: Int) -> Self {
        Endpoint(
            path: "api/character/",
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
//                URLQueryItem(name: "name", value: name),
//                URLQueryItem(name: "status", value: status),
//                URLQueryItem(name: "gender", value: gender),
            ]
        )
    }
}

struct RickAndMortyCharacter: Decodable, Hashable {
    let uuid = UUID()
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: String
    let imageUrl: String
    let created: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case species = "species"
        case gender = "gender"
        case imageUrl = "image"
        case created = "created"
    }
}

// MARK: - CharacterStatus Enum
extension RickAndMortyCharacter {
    enum CharacterStatus: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }
}

class NetworkService: NetworkServiceProtocol {

    let customDecoder = JSONDecoder()
    
    init() {
        setCustomDecoder()
    }
    
    func setCustomDecoder() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        customDecoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    func fetch<T: NetworkRequestProtocol>(_ request: T) async throws -> T.ResponseType {
        var urlRequest = URLRequest(url: request.endpoint.url)
        urlRequest.httpMethod = request.method.rawValue
        let data: T.ResponseType = try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let data = data else { return }
                    do {
                        guard let urlResponse = response as? HTTPURLResponse,
                              (200...299).contains(urlResponse.statusCode) else {
                                  let decodedErrorResponse = try self.customDecoder.decode(APIError.self, from: data)
                                  continuation.resume(throwing: decodedErrorResponse)
                                  return
                              }
                        let decodedData = try self.customDecoder.decode(T.ResponseType.self, from: data)
                        continuation.resume(returning: decodedData)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            .resume()
        }
        return data
    }
}
