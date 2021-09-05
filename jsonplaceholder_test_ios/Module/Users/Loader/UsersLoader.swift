//
//  UsersLoader.swift
//  jsonplaceholder_test_ios
//
//  Created by Andrey Leganov on 9/4/21.
//

import Foundation

enum ServerError: Error {
    case requestFailed
    case notFound
}

class UsersLoader {
        
    func fetchUsers(completion: @escaping (Result<[User], ServerError>) -> Void) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            completion(.failure(.notFound))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(.requestFailed))
            }
        }.resume()
    }
}
