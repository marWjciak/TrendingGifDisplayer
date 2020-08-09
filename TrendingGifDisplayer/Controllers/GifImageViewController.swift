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
        startSpinner(with: self)
        setGifImage()
        setImageConstraints(to: view)
    }

    private func configureBarButtonItems() {
        let shareGifItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(saveGifPressed))
        shareGifItem.tintColor = .systemYellow

        let addToFavourite = UIBarButtonItem(image: K.shared.heartAddSign, style: .plain, target: self, action: #selector(addToFavouritiesPressed))
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
        if favouritieGifController.contains(gif.id) {
            let alert = UIAlertController(title: "Gif already exists", message: K.shared.gifExistsMessage, preferredStyle: .alert)
            alert.addAction(.init(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            favouritieGifController.add(gif: gif)
            let alert = UIAlertController(title: "Success!", message: K.shared.gifAddedMessage, preferredStyle: .alert)
            alert.addAction(.init(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    private func configureView() {
        let view = UIView()
        view.backgroundColor = .black
        gifImage.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(gifImage)
        self.view = view
    }

    private func setGifImage() {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: self.gif.images.original.url)
            if let url = url {
                let data = try? Data(contentsOf: url)

                if let imageData = data {
                    DispatchQueue.main.async { [weak self] in
                        self?.stopSpinner()
                        self?.gifImage.image = UIImage.animatedImage(withData: imageData)
                    }
                }
            }
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
