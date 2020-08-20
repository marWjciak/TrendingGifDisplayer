//
//  XCTestCase+JSON.swift
//  GifsModelTests
//
//  Created by Marcin Wójciak on 08/08/2020.
//

import XCTest
@testable import TrendingGifDisplayer

extension XCTestCase {

    enum TestError: Error {
        case fileNotFound
    }

    func getJSONData() throws -> Gifs? {
        let bundle = Bundle(for: type(of: self))

        if let url = bundle.url(forResource: "Gifs", withExtension: "json") {
        } else {
            XCTFail("Missing file Gifs.json")
            throw TestError.fileNotFound
        }

        let json = try Data(contentsOf: url)
        let gifs = try JSONDecoder().decode(Gifs.self, from: json)

        return gifs
    }
}
