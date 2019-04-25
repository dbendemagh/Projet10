//
//  FakeDataRecepted.swift
//  RecipleaseTests
//
//  Created by Daniel BENDEMAGH on 24/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

// Load json file (or image)
class FakeDataRecepted {
    let correctData: Data
    
    init(file: String, fileExt: String) {
        let bundle = Bundle(for: FakeDataRecepted.self)
        let url = bundle.url(forResource: file, withExtension: fileExt)
        correctData = try! Data(contentsOf: url!)
    }
}
