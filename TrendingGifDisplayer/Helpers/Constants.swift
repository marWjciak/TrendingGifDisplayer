//
//  Constants.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 08/08/2020.
//

import Foundation
import UIKit

struct Constants {
    static let shared = Constants()
    let appName = "Gif Displayer"
    let addToFavouriteText = "Add"
    let removeFromFavouriteText = "Remove"

    let heartEmptyImage = UIImage(named: "heart")
    let heartFilledImage = UIImage(named: "heart.fill")
    let heartAddSign = UIImage(named: "heart.add")
    
    let gifExistsMessage = "Gif you are trying to add already exists in your favourite list."
    let gifAddedMessage = "Added to your favourite list."

    let gifCellIdentifier = "gifCell"
}
