//
//  FakeResponseData.swift
//  RecipleaseTests
//
//  Created by Daniel BENDEMAGH on 03/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class FakeResponseData {
    let responseOK = HTTPURLResponse(url: URL(string: "https://www.google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    let responseKO = HTTPURLResponse(url: URL(string: "https://www.google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    class NetworkError: Error {}
    let networkError = NetworkError()
    
    let correctData: Data
    
    let incorrectData = "erreur".data(using: .utf8)
    
    init(jsonFile: String) {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: jsonFile, withExtension: "json")
        correctData = try! Data(contentsOf: url!)
    }
    
//    static var correctData: Data {
//        let bundle = Bundle(for: FakeResponseData.self)
//        let url = bundle.url(forResource: "Yummly", withExtension: "json")
//        let data = try! Data(contentsOf: url!)
//        return data
//    }
}
