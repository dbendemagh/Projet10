//
//  FakeDataRecepted.swift
//  RecipleaseTests
//
//  Created by Daniel BENDEMAGH on 24/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

// Load json file (or image)
class FakeData {
    let correctData: Data?
    
    init(file: String, fileExt: String) {
        let bundle = Bundle(for: FakeData.self)
        guard let url = bundle.url(forResource: file, withExtension: fileExt) else {
            fatalError("\(file).\(fileExt) not found")
        }
        
        do {
            correctData = try Data(contentsOf: url)
        } catch {
            fatalError("\(file).\(fileExt) could not be loaded")
        }
    }
}
