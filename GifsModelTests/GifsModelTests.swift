//
//  GifsModelTests.swift
//  GifsModelTests
//
//  Created by Marcin Wójciak on 08/08/2020.
//

import XCTest
@testable import TrendingGifDisplayer

class GifsModelTests: XCTestCase {

    func testPaginationMapping() throws {
        guard let gifs = try getJSONData() else { return }
        let pagination = gifs.pagination

        XCTAssertEqual(1, pagination.totalCount)
        XCTAssertEqual(1, pagination.count)
        XCTAssertEqual(0, pagination.offset)
    }

    func testGifMapping() throws {
        guard let gifs = try getJSONData() else { return }

        XCTAssertEqual(1, gifs.data.count)

        let gif = gifs.data[0]
        
        XCTAssertEqual("gif", gif.type)
        XCTAssertEqual("1", gif.id)
        XCTAssertEqual("testUrl", gif.url)
        XCTAssertEqual("testJSON", gif.title)
        XCTAssertEqual("480", gif.images.original.height)
        XCTAssertEqual("testOriginalImageUrl", gif.images.original.url)
        XCTAssertEqual("480", gif.images.original.width)
        XCTAssertEqual("480", gif.images.originalStill.height)
        XCTAssertEqual("testOriginalStillImageUrl", gif.images.originalStill.url)
        XCTAssertEqual("480", gif.images.originalStill.width)
    }
}
