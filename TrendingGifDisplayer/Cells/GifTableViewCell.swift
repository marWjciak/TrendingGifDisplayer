//
//  GifTableViewCell.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 04/08/2020.
//

import SwipeCellKit
import UIKit

private let imageCache = NSCache<AnyObject, AnyObject>()

class GifTableViewCell: SwipeTableViewCell {
    private let gifImageView = UIImageView()
    private var gifHeightConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        contentView.addSubview(gifImageView)
        gifImageView.contentMode = .scaleToFill
        backgroundColor = .black

        setImageConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has never been implemented...")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        gifImageView.image = nil
    }

    func set(with gif: Gif, andDelegate delegate: SwipeTableViewCellDelegate) {
        self.delegate = delegate

        DispatchQueue.global(qos: .background).async {
            let url = URL(string: gif.images.originalStill.url)

            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                DispatchQueue.main.async {
                    self.gifImageView.image = imageFromCache
                    self.gifHeightConstraint?.constant = self.gifImageView.frame.width * imageFromCache.size.height / imageFromCache.size.width
                }
                return
            }

            if let url = url {
                if let imageData = try? Data(contentsOf: url), let imageToCache = UIImage(data: imageData) {
                    DispatchQueue.main.async { [unowned self] in
                        self.gifImageView.image = imageToCache
                        self.gifHeightConstraint?.constant = self.gifImageView.frame.width * imageToCache.size.height / imageToCache.size.width
                    }
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
            }
        }
    }

    private func setImageConstraints() {
        gifImageView.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = gifImageView.heightAnchor.constraint(equalToConstant: 200)
        gifHeightConstraint = heightConstraint

        let constraints = [
            gifImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gifImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gifHeightConstraint ?? heightConstraint

        ]

        NSLayoutConstraint.activate(constraints)
    }
}
