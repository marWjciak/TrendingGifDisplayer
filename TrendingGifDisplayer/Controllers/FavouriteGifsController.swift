//
//  FavouriteGifsController.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 05/08/2020.
//

import Foundation
import UIKit

class FavouriteGifsController {
    static var shared = FavouriteGifsController(defaults: .standard)

    private let defaults: UserDefaults
    private let defaultsKey = "favouriteGifs"
    private(set) lazy var favourites = getList()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func add(gif: Gif) {
        if !favourites.contains(gif.id) {
            favourites.append(gif.id)
        }
        defaults.set(favourites, forKey: defaultsKey)
    }

    func rem(gif: Gif) {
        let gifIndex = favourites.firstIndex(of: gif.id)
        if let index = gifIndex {
            favourites.remove(at: index)
            defaults.set(favourites, forKey: defaultsKey)
        }
    }

    func getList() -> [String] {
        return defaults.stringArray(forKey: defaultsKey) ?? []
    }

    func contains(_ item: String) -> Bool {
        return favourites.contains(item)
    }
}
