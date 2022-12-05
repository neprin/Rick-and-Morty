//
//  NetworkDataFetcher.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/4/22.
//

import Foundation

class NetworkDataFetcher {
    
    var searchCharacter = SearchCharacter()
    
    func fetchCharacters(searchTerm: String, completion: @escaping (GetCharacter?) -> ()) {
        searchCharacter.request(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: GetCharacter.self, from: data)
            completion(decode)
        }
    }
    
    //let getCharacter = try? newJSONDecoder().decode(GetCharacter.self, from: jsonData)
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
