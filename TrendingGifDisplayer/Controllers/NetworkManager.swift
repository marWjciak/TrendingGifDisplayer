//
//  NetworkingManager.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 18/08/2020.
//

import Foundation

class NetworkManager {
    
    func getResponseFromServer(urlString: String = "http://api.giphy.com/v1/gifs/trending?api_key=7fZEqVczx5ZTQk64kHJ0dPDDZCazxtF0",
                               parameters: [String] = [],
                               completed: @escaping (Result<ApiData, GGError>) -> Void) {
        
        guard let url = URL(string: "\(urlString)&\(parameters.joined(separator: "&"))") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let data = try JSONDecoder().decode(ApiData.self, from: data)
                completed(.success(data))
            } catch {
                completed(.failure(.invalidData))
            }
        }.resume()
    }
}
