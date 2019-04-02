//
//  Recipe.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 20/02/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct Recipes: Decodable {
    let matches: [Recipe]
}

struct Recipe: Decodable {
    let sourceDisplayName: String
    let ingredients: [String]
    let id: String
    let smallImageUrls: [String]
    let recipeName: String
    let totalTimeInSeconds: Int
    let rating: Int
}


