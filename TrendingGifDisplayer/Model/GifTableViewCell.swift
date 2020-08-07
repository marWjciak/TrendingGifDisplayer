//
//  GifTableViewCell.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 04/08/2020.
//

import SwipeCellKit
import UIKit

class GifTableViewCell: SwipeTableViewCell {
    private let gifImageView = UIImageView()

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
            let url = URL(string: gif.images.fixedWidthStill.url)
            if let url = url {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        self?.gifImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }

    private func setImageConstraints() {
        gifImageView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            gifImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gifImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
