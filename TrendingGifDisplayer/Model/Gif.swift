//
//  Giph.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 04/08/2020.
//

import Foundation

struct Gif: Decodable {
    var type: String
    var id: String
    var url: String
    var title: String
    var images: GifImages
    var isFavourite: Bool = false

    enum CodingKeys: String, CodingKey {
        case type
        case id
        case url
        case title
        case images
    }
}

struct GifImages: Decodable {
    var fixedWidth: GifImage
    var fixedWidthStill: GifImage

    enum CodingKeys: String, CodingKey {
        case fixedWidth = "fixed_width"
        case fixedWidthStill = "fixed_width_still"
    }
}

struct GifImage: Decodable {
    var url: String
    var height: String
    var width: String
}
