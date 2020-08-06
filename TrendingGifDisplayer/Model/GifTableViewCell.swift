//
//  GifTableViewCell.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 04/08/2020.
//

import SwipeCellKit
import UIKit

class GifTableViewCell: SwipeTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has never been implemented...")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView?.image = UIImage(named: "Black")
    }

    func set(with gif: Gif, andDelegate delegate: SwipeTableViewCellDelegate) {
        self.delegate = delegate

        DispatchQueue.global(qos: .background).async {
            let url = URL(string: gif.images.fixedWidthStill.url)
            if let url = url {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.setImageConstraints()
                        self.imageView?.image = UIImage(data: imageData)
                    }
                }
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
