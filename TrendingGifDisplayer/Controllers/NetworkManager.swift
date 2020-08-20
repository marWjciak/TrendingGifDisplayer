//
//  NetworkingManager.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 18/08/2020.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private let gifsApiUrlText = "http://api.giphy.com/v1/gifs/trending?api_key=7fZEqVczx5ZTQk64kHJ0dPDDZCazxtF0"

    var totalGifList: [Gif] = []

    func getGifs(for pageNumber: Int, count: Int, completed: @escaping (Result<[Gif], GGError>) -> Void) {
        let url = URL(string: "\(gifsApiUrlText)&offset=\(pageNumber * count)")

        guard let safeUrl = url else { return }

        let task = URLSession.shared.dataTask(with: safeUrl) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let gifs = try JSONDecoder().decode(Gifs.self, from: data)
                completed(.success(gifs.data))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func getPaginationInfo(completed: @escaping (Result<Pagination, GGError>) -> Void) {
        guard let safeUrl = URL(string: gifsApiUrlText) else { return }

        let task = URLSession.shared.dataTask(with: safeUrl) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let gifs = try JSONDecoder().decode(Gifs.self, from: data)
                completed(.success(gifs.pagination))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
