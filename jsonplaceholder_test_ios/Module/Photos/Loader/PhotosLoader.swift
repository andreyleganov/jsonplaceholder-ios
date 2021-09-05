//
//  PhotosLoader.swift
//  jsonplaceholder_test_ios
//
//  Created by Andrey Leganov on 9/4/21.
//

import Foundation

class PhotosLoader {
    
    func fetchPhotos(albumId: Int, completion: @escaping (Result<[Photo], ServerError>) -> Void) {

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
            completion(.failure(.notFound))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
              
                completion(.success(photos.filter {$0.albumId == albumId}))
            } catch {
                completion(.failure(.requestFailed))
            }
        }.resume()
    }
    
    func fetchPhotos(userId: Int, completion: @escaping (Result<[Photo], ServerError>) -> Void) {
        fetchAlbums(userId: userId) { result in
            switch result {
            case .success(let albums):
                guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
                    completion(.failure(.notFound))
                    return
                }
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    
                    do {
                        let photos = try JSONDecoder().decode([Photo].self, from: data)
                        var userPhotos = [Photo]()
                        for album in albums {
                            userPhotos.append(contentsOf: photos.filter {$0.albumId == album.id})
                        }
                        completion(.success(userPhotos))
                    } catch {
                        completion(.failure(.requestFailed))
                    }
                }.resume()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchAlbums(userId: Int, completion: @escaping (Result<[Album], ServerError>) -> Void) {
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
