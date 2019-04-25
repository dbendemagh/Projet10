//
//  FakeResponse.swift
//  RecipleaseTests
//
//  Created by Daniel BENDEMAGH on 03/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct FakeResponse {
    var httpResponse: HTTPURLResponse?
    var data: Data?
    var error: Error?
}
