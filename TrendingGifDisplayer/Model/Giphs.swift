//
//  Giphs.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 04/08/2020.
//

import Foundation

struct Gifs: Decodable {
    var data: [Giph]
    var pagination: Pagination
}

struct Pagination: Decodable {
    var totalCount: String
    var count: String
    var offset: String

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count
        case offset
    }
}
