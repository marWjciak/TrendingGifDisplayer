//
//  GifImageViewController.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 06/08/2020.
//

import Foundation
import GIFImageView

class GifImageViewController: UIViewController {
    var gifImage = UIImageView()
    var gif: Gif

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

        if let width = NumberFormatter().number(from: gif.images.fixedWidth.width) {
            let imageWidth = CGFloat(truncating: width)
            gifImage.frame.size.width = imageWidth
        }
        if let height = NumberFormatter().number(from: gif.images.fixedWidth.height) {
            let imageHeight = CGFloat(truncating: height)
            gifImage.frame.size.height = imageHeight
        }

        gifImage.center = self.view.center

        guard let animatedImage = getImage() else { return }
        gifImage.image = animatedImage

        view.addSubview(gifImage)

        self.view = view
    }

    func getImage() -> UIImage? {
        var image: UIImage?

        let url = URL(string: gif.images.fixedWidth.url)
        if let url = url {
            let data = try? Data(contentsOf: url)

            if let imageData = data {
                image = UIImage.animatedImage(withData: imageData)
            }
        }
        guard let safeImage = image else { return nil }

        return safeImage
    }
}
