//
//  GGError.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 19/08/2020.
//

import Foundation

enum GGError: String, Error {
    case unableToComplete = "Unable to complete your request."
    case invalidResponse = "Invalid response from the server."
    case invalidData = "The data received from the server was invalid. Please try again."
    case alreadyInFavourites = "You've already favourited this gif."
}
