//
//  HomeTableViewController.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 04/08/2020.
//

import Spinners
import SwipeCellKit
import UIKit

class HomeTableViewController: UITableViewController {
    var showFavourities: Bool = false
    var totalGifList: [Gif] = []

    private let favouritieGifController = FavouriteGifsController.shared
    private let footerSpinner = UIActivityIndicatorView(style: .whiteLarge)
    private var pageNumber: Int = 0
    private var count: Int = 0
    private var totalItems: Int = 0

    private var gifList: [Gif] {
        if showFavourities {
            return totalGifList.filter { gif in
                favouritieGifController.contains(gif.id)
            }
        } else {
            return totalGifList
        }
    }

    private var favouriteImage: UIImage? {
        if showFavourities {
            return Constants.shared.heartFilledImage ?? nil
        } else {
            return Constants.shared.heartEmptyImage ?? nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBarButtonItems()
        configureNavigationController()
        configureTableView()

        getPagination()
        getGifsFromServer()
    }

    // MARK: - TableView Delegate & DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.shared.gifCellIdentifier, for: indexPath) as! GifTableViewCell

        cell.set(with: gifList[indexPath.row], andDelegate: self)

        let animation = AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == gifList.count - 1, totalItems > gifList.count, !showFavourities {
            DispatchQueue.main.async { [weak self] in
                self?.footerSpinner.startAnimating()
            }
            getGifsFromServer()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = GifImageViewController(with: gifList[indexPath.row])
        navigationController?.pushViewController(destinationVC, animated: true)
    }

    // MARK: - Private methods

    private func configureBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: favouriteImage,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showFavouritiesPressed))
        navigationItem.rightBarButtonItem?.tintColor = .red
    }

    @objc private func showFavouritiesPressed() {
        showFavourities = !showFavourities
        navigationItem.rightBarButtonItem?.image = favouriteImage
        UIView.transition(with: tableView,
                          duration: 1,
                          options: .transitionFlipFromRight,
                          animations: { self.tableView.reloadData() }, completion: nil)
    }

    private func configureNavigationController() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemYellow]
        navigationController?.navigationBar.topItem?.title = Constants.shared.appName
        navigationController?.delegate = self
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.register(GifTableViewCell.self, forCellReuseIdentifier: Constants.shared.gifCellIdentifier)

        footerSpinner.color = .systemYellow
        footerSpinner.hidesWhenStopped = true
        tableView.tableFooterView = footerSpinner
        tableView.tableFooterView?.backgroundColor = .black
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func getPagination() {
        NetworkManager.shared.getPaginationInfo { result in
            switch result {
                case .success(let pagination):
                    self.count = pagination.count
                    self.totalItems = pagination.totalCount
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presentAlertPopup(title: "Failure",
                                               message: "Cannot get Pagination info. \n\(error.localizedDescription)",
                                               actions: [
                                                   UIAlertAction(title: "Try again", style: .default, handler: { _ in self.getPagination() }),
                                                   UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                               ])
                    }
            }
        }
    }

    private func getGifsFromServer() {
        startSpinner()

        NetworkManager.shared.getGifs(for: pageNumber, count: count) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let gifs):
                    self.pageNumber += 1
                    self.totalGifList.append(contentsOf: gifs)

                    dismissSpinner(spinner: self.footerSpinner)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                case .failure(let error):
                    print(error.localizedDescription)
            }
            self.stopSpinner()
        }
    }
}

private func dismissSpinner(spinner: UIActivityIndicatorView) {
    DispatchQueue.main.async {
        if spinner.isAnimating {
            spinner.stopAnimating()
        }
    }
}

extension HomeTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        guard indexPath.row < gifList.count else { return nil }

        let toFavouriteAction = SwipeAction(style: .default, title: "") { _, indexPath in

            if self.favouritieGifController.contains(self.gifList[indexPath.row].id) {
                self.favouritieGifController.rem(gif: self.gifList[indexPath.row])
                if self.showFavourities {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            } else {
                self.favouritieGifController.add(gif: self.gifList[indexPath.row])
            }
        }

        toFavouriteAction.backgroundColor = .systemBlue

        if favouritieGifController.contains(gifList[indexPath.row].id) {
            toFavouriteAction.image = Constants.shared.heartFilledImage
            toFavouriteAction.title = Constants.shared.removeFromFavouriteText
        } else {
            toFavouriteAction.image = Constants.shared.heartEmptyImage
            toFavouriteAction.title = Constants.shared.addToFavouriteText
        }

        return [toFavouriteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()

        options.expansionStyle = .selection

        return options
    }
}

extension HomeTableViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
            case .push,
                 .pop:
                return FadeInAnimator()
            default:
                return nil
        }
    }
}
