//
//  FakeDataResponse.swift
//  RecipleaseTests
//
//  Created by Daniel BENDEMAGH on 28/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class FakeJsonResponse {
    let correctData: Data
    
    init(jsonFile: String) {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: jsonFile, withExtension: "json")
        correctData = try! Data(contentsOf: url!)
    }
}
