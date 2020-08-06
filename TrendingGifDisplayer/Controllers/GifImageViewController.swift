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
    var gifImage = UIImageView()
    var gif: Gif
    var spinner = Spinners()

    init(with gif: Gif) {
        self.gif = gif
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has never been implemented...")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = UIView()
        view.backgroundColor = .black

        gifImage.contentMode = UIView.ContentMode.scaleAspectFit

//        if let width = NumberFormatter().number(from: gif.images.fixedWidth.width) {
//            let imageWidth = CGFloat(truncating: width)
//            gifImage.frame.size.width = imageWidth
//        }
//        if let height = NumberFormatter().number(from: gif.images.fixedWidth.height) {
//            let imageHeight = CGFloat(truncating: height)
//            gifImage.frame.size.height = imageHeight
//        }

        spinner = Spinners(type: .cube, with: self)
        spinner.setCustomSettings(borderColor: .systemYellow, backgroundColor: .clear, alpha: 0.8)

        DispatchQueue.main.async {
            self.spinner.present()
        }

        setGifImage()
        gifImage.center = self.view.center

        view.addSubview(gifImage)

        self.view = view

        setImageConstraints(to: view)
    }

    func setGifImage() {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: self.gif.images.fixedWidth.url)
            if let url = url {
                let data = try? Data(contentsOf: url)

                if let imageData = data {
                    DispatchQueue.main.async {
                        self.spinner.dismiss()
                        self.gifImage.image = UIImage.animatedImage(withData: imageData)
                    }
                }
            }
        }
    }

    func setImageConstraints(to view: UIView) {
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
