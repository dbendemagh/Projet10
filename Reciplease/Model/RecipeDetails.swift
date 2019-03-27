//
//  Detail.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 23/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct RecipeDetails: Decodable {
    //let yield: String
    //let nutritionEstimates: [JSONAny]
    let totalTime: String
    let images: [Image]
    let name: String
    //let source: Source
    let id: String
    let ingredientLines: [String]
    //let cookTime: String?
    //let attribution: Attribution
    let numberOfServings, totalTimeInSeconds: Int
    let attributes: Attributes0
    //let cookTimeInSeconds: Int
    let flavors: Flavors
    let rating: Int
}

struct Attributes0: Decodable {
    let course: [String]
}

struct Attribution: Decodable {
    let html: String
    let url: String // Directions
    let text: String
    let logo: String
}

struct Flavors: Decodable {
}

struct Image: Decodable {
    let hostedSmallURL, hostedMediumURL, hostedLargeURL: String
    let imageUrlsBySize: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case hostedSmallURL = "hostedSmallUrl"
        case hostedMediumURL = "hostedMediumUrl"
        case hostedLargeURL = "hostedLargeUrl"
        case imageUrlsBySize
    }
}

struct Source: Decodable {
    let sourceDisplayName, sourceSiteURL: String
    let sourceRecipeURL: String
    
    enum CodingKeys: String, CodingKey {
        case sourceDisplayName
        case sourceSiteURL = "sourceSiteUrl"
        case sourceRecipeURL = "sourceRecipeUrl"
    }
}
