//
//  FavouriteGifsControllerTests.swift
//  FavouriteGifsControllerTests
//
//  Created by Marcin Wójciak on 08/08/2020.
//

@testable import TrendingGifDisplayer
import XCTest

class FavouriteGifsControllerTests: XCTestCase {
    var favouriteGifsController: FavouriteGifsController!

    override func setUp() {
        super.setUp()

        favouriteGifsController = FavouriteGifsController(defaults: MockUserDefaults(suiteName: "favouriteGifs")!)
    }

    func testAdd() {
        let gifImages = GifImages(original: GifImage(url: "", height: "", width: ""),
                                  originalStill: GifImage(url: "", height: "", width: ""))
        let gif = Gif(type: "", id: "1234", url: "", title: "", images: gifImages)

        XCTAssertEqual(0, favouriteGifsController.favourites.count)

        favouriteGifsController.addFavoutire(gif: gif)
        XCTAssertEqual(1, favouriteGifsController.favourites.count)
        XCTAssertEqual("1234", favouriteGifsController.favourites[0])

        favouriteGifsController.addFavoutire(gif: gif)
        XCTAssertEqual(1, favouriteGifsController.favourites.count)
    }

    func testGetList() {
        let gifImages = GifImages(original: GifImage(url: "", height: "", width: ""),
                                  originalStill: GifImage(url: "", height: "", width: ""))
        let gif = Gif(type: "", id: "1234", url: "", title: "", images: gifImages)

        XCTAssertEqual(0, favouriteGifsController.favourites.count)

        favouriteGifsController.addFavoutire(gif: gif)

        let gifIDs = favouriteGifsController.getList()

        XCTAssertEqual(1, gifIDs.count)
        XCTAssertEqual(["1234"], gifIDs)
    }

    func testRem() {
        let gifImages = GifImages(original: GifImage(url: "", height: "", width: ""),
                                  originalStill: GifImage(url: "", height: "", width: ""))
        let gif = Gif(type: "", id: "1234", url: "", title: "", images: gifImages)

        favouriteGifsController.addFavoutire(gif: gif)
        XCTAssertEqual(1, favouriteGifsController.favourites.count)

        favouriteGifsController.removeFavourite(gif: gif)
        XCTAssertEqual(0, favouriteGifsController.favourites.count)
    }
}
