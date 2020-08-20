//
//  Result.swift
//  TrendingGifDisplayer
//
//  Created by Marcin Wójciak on 19/08/2020.
//

import Foundation

enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
