//
//  Detail.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 23/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct YummlyRecipeDetails: Decodable {
    let images: [Image]
    let name: String
    let source: Source
    let id: String
    let ingredientLines: [String]
    let totalTimeInSeconds: Int
    let rating: Int
}

struct Image: Decodable {
    let hostedLargeUrl: String
}

struct Source: Decodable {
    let sourceRecipeUrl: String
}
