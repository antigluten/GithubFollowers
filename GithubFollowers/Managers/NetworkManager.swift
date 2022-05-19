//
//  NetworkManager.swift
//  GithubFollowers
//
//  Created by Vladimir Gusev on 17.05.2022.
//

import UIKit

// optimization with method dispatch
final class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseUrl = "https://api.github.com/users/"
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func download(from url: String, completion: @escaping (Result<Data, GFError>) -> Void ) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(data))
        }
        
        task.resume()
    }
    
    func downloadImage(from url: String, completion: @escaping (Result<UIImage?, GFError>) -> ()) {
        let cacheKey = NSString(string: url)
        
        if let image = cache.object(forKey: cacheKey) {
            print("Loading cached image")
            completion(.success(image))
            return
        }
        
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            
            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            let image = UIImage(data: data)
            
            guard let image = image else {
                completion(.failure(.invalidData))
                return
            }

            print("donwloading image and setting to cache")
            self.cache.setObject(image, forKey: cacheKey)
            
            completion(.success(image))
        }
        
        task.resume()
    }
}
