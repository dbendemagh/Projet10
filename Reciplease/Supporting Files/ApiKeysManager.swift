//
//  ApiKeysManager.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 02/05/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

final class ApiKeysManager {
    private lazy var apiKeys: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") else {
            fatalError("ApiKeys.plist not found")
        }
        return NSDictionary(contentsOfFile: path) ?? [:]
    }()
    
    var yummlyId: String {
        return apiKeys["yummlyId"] as? String ?? String()
    }
    
    var yummlyKey: String {
        return apiKeys["yummlyKey"] as? String ?? String()
    }
}
