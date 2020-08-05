//
//  GifTableViewCell.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 04/08/2020.
//

import UIKit
import SwipeCellKit

class GifTableViewCell: SwipeTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setImageConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has never been implemented...")
    }

    func set(with gif: Gif, andDelegate delegate: SwipeTableViewCellDelegate) {
        self.delegate = delegate
        
        let url = URL(string: gif.images.fixedWidthStill.url)
        if let url = url {
            let data = try? Data(contentsOf: url)

            if let imageData = data {
                imageView?.image = UIImage(data: imageData)
            }
        }
    }

    func setImageConstraints() {
        guard let imageView = imageView else { return }

        imageView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
