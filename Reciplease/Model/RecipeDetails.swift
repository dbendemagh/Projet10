//
//  RecipeDetails.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 05/05/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct RecipeDetails {
    let name: String
    let id: String
    let time: String
    let rating: String
    let urlImage: String
    var image: Data?
    let ingredients: [String]
    let ingredientsDetail: [String]
    let urlDirections: String
}
