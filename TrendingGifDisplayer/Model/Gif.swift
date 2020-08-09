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

    enum CodingKeys: String, CodingKey {
        case type
        case id
        case url
        case title
        case images
    }
}

extension Gif: Comparable {
    static func < (lhs: Gif, rhs: Gif) -> Bool {
        return lhs.id < rhs.id
    }

    static func == (lhs: Gif, rhs: Gif) -> Bool {
        return rhs.id == lhs.id
    }
}

struct GifImages: Decodable {
    var original: GifImage
    var originalStill: GifImage

    enum CodingKeys: String, CodingKey {
        case original
        case originalStill = "original_still"
    }
}

struct GifImage: Decodable {
    var url: String
    var height: String
    var width: String
}
