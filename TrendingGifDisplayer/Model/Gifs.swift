//
//  Giphs.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 04/08/2020.
//

import Foundation

struct Gifs: Decodable {
    var data: [Gif]
    var pagination: Pagination
}

struct Pagination: Decodable {
    var totalCount: Int
    var count: Int
    var offset: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count
        case offset
    }
}
