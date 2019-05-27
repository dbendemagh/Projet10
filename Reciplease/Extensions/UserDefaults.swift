//
//  UserDefaults.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 26/05/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

extension UserDefaults {
    func loadIngredients() -> [String] {
        guard let list = UserDefaults.standard.array(forKey: UserDefaultsKeys.ingredientsList) as? [String] else { return [] }
        return list
    }
    
    func saveIngredients(list: [String]) {
        UserDefaults.standard.set(list, forKey: UserDefaultsKeys.ingredientsList)
    }
}
