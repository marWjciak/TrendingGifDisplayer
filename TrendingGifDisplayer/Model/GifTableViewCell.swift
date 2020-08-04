//
//  GifTableViewCell.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 04/08/2020.
//

import UIKit

class GifTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

//        setImageConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has never been implemented...")
    }

    func set(with gif: Gif) {
        let url = URL(string: gif.images.fixedWidthStill.url)
        if let url = url {
            let data = try? Data(contentsOf: url)

            if let imageData = data {
                imageView?.image = UIImage(data: imageData)
                setImageConstraints(for: gif.images.fixedWidthStill)
            }
        }
    }

    func setImageConstraints(for image: GifImage) {
        imageView?.translatesAutoresizingMaskIntoConstraints = false

        imageView?.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        imageView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        imageView?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
    }
}
