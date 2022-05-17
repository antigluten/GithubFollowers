//
//  NetworkManager.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 17.05.2022.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    let baseUrl = "https://api.github.com/users"
    
    private init() { }
    
    func getFollowers(for username: String, page: Int, completion: @escaping ([Follower]?, String?) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completion(nil, "Invalid request")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(nil, "Error happened during completing request")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Invalid response from server")
                return
            }
            
            
            guard let data = data else {
                completion(nil, "The data received was invalid")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(followers, nil)
            } catch {
                completion(nil, "Unable to convert data to followers")
            }
        }
        
        task.resume()
    }
}
