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
    private var spinner = Spinners()

    init(with gif: Gif) {
        self.gif = gif
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has never been implemented...")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(saveGifPressed))
        navigationItem.rightBarButtonItem?.tintColor = .systemYellow

        navigationController?.navigationBar.tintColor = .systemYellow

        let view = UIView()
        view.backgroundColor = .black

        gifImage.contentMode = UIView.ContentMode.scaleAspectFit

        spinner = Spinners(type: .cube, with: self)
        spinner.setCustomSettings(borderColor: .systemYellow, backgroundColor: .clear, alpha: 0.8)

        DispatchQueue.main.async { [weak self] in
            self?.spinner.present()
        }

        setGifImage()
        gifImage.center = self.view.center

        view.addSubview(gifImage)

        self.view = view

        setImageConstraints(to: view)
    }

    @objc private func saveGifPressed() {
        let shareURL = URL(string: gif.images.fixedWidth.url)
        let shareData = try? Data(contentsOf: shareURL!)
        let gifData: [Any] = [shareData as Any]

        let activityViewController: UIActivityViewController =
            UIActivityViewController(activityItems: gifData, applicationActivities: nil)

        activityViewController.popoverPresentationController?.sourceView = view

        present(activityViewController, animated: true, completion: nil)
    }

    private func setGifImage() {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: self.gif.images.fixedWidth.url)
            if let url = url {
                let data = try? Data(contentsOf: url)

                if let imageData = data {
                    DispatchQueue.main.async { [weak self] in
                        self?.spinner.dismiss()
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
