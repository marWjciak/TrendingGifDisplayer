//
//  GifImageViewController.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 06/08/2020.
//

import Foundation
import GIFImageView
import Spinners

class GifImageViewController: UIViewController {
    private var gifImage = UIImageView()
    private var gif: Gif
    private let favouritieGifController = FavouriteGifsController.shared

    init(with gif: Gif) {
        self.gif = gif
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has never been implemented...")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBarButtonItems()
        configureView()
        setGifImage()
        setImageConstraints(to: view)
    }

    private func configureBarButtonItems() {
        let shareGifItem = UIBarButtonItem(barButtonSystemItem: .action,
                                           target: self,
                                           action: #selector(saveGifPressed))
        shareGifItem.tintColor = .systemYellow

        let addToFavourite = UIBarButtonItem(image: Constants.shared.heartAddSign,
                                             style: .plain,
                                             target: self,
                                             action: #selector(addToFavouritiesPressed))
        addToFavourite.tintColor = .systemYellow

        navigationItem.rightBarButtonItems = [shareGifItem, addToFavourite]
        navigationController?.navigationBar.tintColor = .systemYellow
    }

    @objc private func saveGifPressed() {
        let shareURL = URL(string: gif.images.original.url)
        let shareData = try? Data(contentsOf: shareURL!)
        let gifData: [Any] = [shareData as Any]

        let activityViewController: UIActivityViewController =
            UIActivityViewController(activityItems: gifData, applicationActivities: nil)

        activityViewController.popoverPresentationController?.sourceView = view

        present(activityViewController, animated: true, completion: nil)
    }

    @objc private func addToFavouritiesPressed() {
        var title = ""
        var message = ""

        if favouritieGifController.contains(gif.id) {
            title = "Gif already exists"
            message = Constants.shared.gifExistsMessage
        } else {
            favouritieGifController.addFavoutire(gif: gif)
            title = "Success"
            message = Constants.shared.gifAddedMessage
        }

        presentAlertPopup(title: title,
                          message: message,
                          actions: [UIAlertAction(title: "Ok", style: .cancel, handler: nil)])
    }

    private func configureView() {
        let view = UIView()
        view.backgroundColor = .black
        gifImage.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(gifImage)
        self.view = view
    }

    private func setGifImage() {
        startSpinner()
        getImage(from: gif.images.original.url) { result in
            switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.gifImage.image = image
                    }
                case .failure(let error):
                    self.presentAlertPopup(title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "Ok", style: .default, handler: nil)])
            }
            self.stopSpinner()
        }
    }

    private func getImage(from urlText: String, completed: @escaping (Result<UIImage, GGError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: urlText)

            if let url = url {
                let data = try? Data(contentsOf: url)

                if let imageData = data {
                    guard let image = UIImage.animatedImage(withData: imageData) else {
                        completed(.failure(.invalidData))
                        return
                    }

                    completed(.success(image))
                    return
                }
            }
            completed(.failure(.unableToComplete))
        }
    }

    private func setImageConstraints(to view: UIView) {
        gifImage.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            gifImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gifImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            gifImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            gifImage.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 10),
            gifImage.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
