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

//struct Attribution: Codable {
//    let html: String
//    let url: String
//    let text: String
//    let logo: String
//}

struct Recipe: Decodable {
    //let imageUrlsBySize: ImageUrlsBySize
    let sourceDisplayName: String
    let ingredients: [String]
    let id: String
    let smallImageUrls: [String]
    let recipeName: String
    let totalTimeInSeconds: Int
    let attributes: Attributes
    //let flavors: JSONNull?
    let rating: Int
}

struct Attributes: Codable {
    let course: [String]
}

//enum Course: String, Codable {
//    case desserts = "Desserts"
//}

struct ImageUrlsBySize: Decodable {
    let the90: String
    
    enum CodingKeys: String, CodingKey {
        case the90 = "90"
    }
}
