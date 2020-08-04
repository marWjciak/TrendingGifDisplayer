//
//  HomeTableViewController.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 04/08/2020.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var gifList: [Gif] = []
    var pageNumber: Int = 0
    var count: Int = 0
    var totalItems: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GifTableViewCell.self, forCellReuseIdentifier: "gifCell")

        fetchGifs()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell") as! GifTableViewCell
        cell.set(with: gifList[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == gifList.count - 1, totalItems > gifList.count {
            fetchGifs()
        }
    }

    func fetchGifs() {
        let url = URL(string: "https://api.giphy.com/v1/gifs/trending?api_key=7fZEqVczx5ZTQk64kHJ0dPDDZCazxtF0&offset=\(pageNumber * count)")

        guard let safeUrl = url else { return }

        let task = URLSession.shared.dataTask(with: safeUrl) { data, _, _ in
            guard let data = data else { return }

            do {
                let gifs = try JSONDecoder().decode(Gifs.self, from: data)
                gifs.data.forEach { (gif) in
                    self.gifList.append(gif)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                self.count = gifs.pagination.count
                self.totalItems = gifs.pagination.totalCount
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        pageNumber += 1
    }
}
