//
//  MockUserDefaults.swift
//  FavouriteGifsControllerTests
//
//  Created by Marcin Wójciak on 09/08/2020.
//

import Foundation

class MockUserDefaults: UserDefaults {

    convenience init() {
        self.init(suiteName: "Mock User Defaults")!
    }

    override init?(suiteName suitename: String?) {
        UserDefaults().removePersistentDomain(forName: suitename!)
        super.init(suiteName: suitename)
    }
}
