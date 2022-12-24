//
//  NetworkService.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//

import UIKit

class NetworkService: NetworkServiceProtocol {
    
    let customDecoder = JSONDecoder()
    
    func setCustomDecoder() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        customDecoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    init() {
        setCustomDecoder()
    }
    
    func fetch<T: NetworkRequestProtocol>(_ request: T) async throws -> T.ResponseType {
        
        var urlRequest = URLRequest(url: request.endpoint.url)
        urlRequest.httpMethod = request.method.rawValue
        
        let data: T.ResponseType = try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data else { return }
                do {
                    guard response != nil else { return }
                    let decodedData = try self.customDecoder.decode(T.ResponseType.self, from: data)
                    continuation.resume(returning: decodedData)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            .resume()
        }
        return data
    }
}
