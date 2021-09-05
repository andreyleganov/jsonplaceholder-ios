//
//  AlbumsLoader.swift
//  jsonplaceholder_test_ios
//
//  Created by Andrey Leganov on 9/6/21.
//

import Foundation

class AlbumsLoader {
    
    func fetchAlbums(userId: Int, completion: @escaping (Result<[Album], ServerError>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/albums") else {
            completion(.failure(.notFound))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let albums = try JSONDecoder().decode([Album].self, from: data)
                completion(.success(albums.filter {$0.userId == userId}))
            } catch {
                completion(.failure(.requestFailed))
            }
        }.resume()
    }
    
}
