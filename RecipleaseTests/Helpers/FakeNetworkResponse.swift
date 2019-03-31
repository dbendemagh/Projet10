//
//  FakeNetworkResponse.swift
//  RecipleaseTests
//
//  Created by Daniel BENDEMAGH on 28/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class FakeNetworkResponse {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://www.google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO = HTTPURLResponse(url: URL(string: "https://www.google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    class NetworkError: Error {}
    static let networkError = NetworkError()
    
    static let incorrectData = "erreur".data(using: .utf8)
}
