//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 25/02/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.reloadData()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(recipe: recipes[indexPath.row])
        
        return cell
    }
}

extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
