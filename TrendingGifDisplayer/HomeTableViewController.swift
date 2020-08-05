//
//  HomeTableViewController.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 04/08/2020.
//

import SwipeCellKit
import Spinners
import UIKit

class HomeTableViewController: UITableViewController {
    let favouritieGifController = FavouriteGifsController(defaults: .standard)
    var spinner = Spinners()
    let footerSpinner = UIActivityIndicatorView(style: .whiteLarge)
    var pageNumber: Int = 0
    var count: Int = 0
    var totalItems: Int = 0
    var showFavourities: Bool = false
    var totalGifList: [Gif] = []

    var filteredGifList: [Gif] {
        return gifList.filter { favouritieGifController.contains($0.id) }
    }

    var gifList: [Gif] {
        if showFavourities {
            return totalGifList.filter { gif in
                favouritieGifController.contains(gif.id)
            }
        } else {
            return totalGifList
        }
    }

    var favouriteImage: UIImage? {
        if showFavourities {
            return UIImage(named: "heart.fill") ?? nil
        } else {
            return UIImage(named: "heart") ?? nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: favouriteImage, style: .plain, target: self, action: #selector(showFavouritiesPressed))
        navigationItem.rightBarButtonItem?.tintColor = .red
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemYellow]
        navigationController?.navigationBar.topItem?.title = "Gif Displayer"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.register(GifTableViewCell.self, forCellReuseIdentifier: "gifCell")

        spinner = Spinners(type: .cube, with: self)
        spinner.setCustomSettings(borderColor: .systemYellow, backgroundColor: .clear, alpha: 0.8)

        footerSpinner.color = .systemYellow
        footerSpinner.hidesWhenStopped = true
        tableView.tableFooterView = footerSpinner
        tableView.tableFooterView?.backgroundColor = .black

        fetchGifs()
    }

    @objc private func showFavouritiesPressed() {
        showFavourities = !showFavourities
        navigationItem.rightBarButtonItem?.image = favouriteImage
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell") as! GifTableViewCell

        cell.set(with: gifList[indexPath.row], andDelegate: self)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == gifList.count - 1, totalItems > gifList.count, !showFavourities {
            DispatchQueue.main.async {
                self.footerSpinner.startAnimating()
            }
            fetchGifs()
        }
    }

    func fetchGifs() {
        let url = URL(string: "https://api.giphy.com/v1/gifs/trending?api_key=7fZEqVczx5ZTQk64kHJ0dPDDZCazxtF0&offset=\(pageNumber * count)")

        guard let safeUrl = url else { return }

        let task = URLSession.shared.dataTask(with: safeUrl) { data, _, _ in
            guard let data = data else { return }

            do {
                DispatchQueue.main.async {
                    self.spinner.present()
                }
                let gifs = try JSONDecoder().decode(Gifs.self, from: data)
                gifs.data.forEach { gif in
                    self.totalGifList.append(gif)
                }
                DispatchQueue.main.async {
                    self.spinner.dismiss()

                    if self.footerSpinner.isAnimating {
                        self.footerSpinner.stopAnimating()
                    }

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

extension HomeTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        guard indexPath.row < gifList.count else { return nil }

        let toFavouriteAction = SwipeAction(style: .default, title: "Favourite") { _, indexPath in

            if self.favouritieGifController.contains(self.gifList[indexPath.row].id) {
                self.favouritieGifController.rem(gif: self.gifList[indexPath.row])
                if self.showFavourities {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            } else {
                self.favouritieGifController.add(gif: self.gifList[indexPath.row])
            }

            if self.showFavourities {
                tableView.reloadData()
            }
        }

        toFavouriteAction.backgroundColor = .systemBlue

        if favouritieGifController.contains(gifList[indexPath.row].id) {
            toFavouriteAction.image = UIImage(named: "heart.fill")
        } else {
            toFavouriteAction.image = UIImage(named: "heart")
        }

        return [toFavouriteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()

        options.expansionStyle = .selection

        return options
    }
}
