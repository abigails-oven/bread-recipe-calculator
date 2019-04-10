//
//  RecipesListViewController.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/10/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation
import UIKit


class RecipesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UIViewController


    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - TableView


    @IBOutlet private weak var tableView: UITableView!

    private func setupTableView() {
        // Prevent empty cells from being displayed
        self.tableView.tableFooterView = UIView()
    }


    // MARK: - UITableViewDataSource


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueCell(in: tableView)
        let recipe = self.recipes[indexPath.row]
        cell.textLabel?.text = recipe.title
        return cell
    }


    // MARK: - Table View Cells


    private let cellReuseId: String = "cellReuseId"

    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseId) {
            return cell
        }

        let cell = UITableViewCell(style: .default, reuseIdentifier: self.cellReuseId)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }


    // MARK: - UITableViewDelegate


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = self.recipes[indexPath.row]
        let detailView = RecipeDetailViewController.initFromStoryboard()
        RecipeDetailConfig(detailView, recipe)
        self.navigationController?.pushViewController(detailView, animated: true)
    }


    // MARK: - Test


    private var recipes: [Recipe] {
        return TestRecipesDataSource.shared.recipes
    }
}


class TestRecipesDataSource {

    static let shared: TestRecipesDataSource = .init()
    let recipes: [Recipe] = Recipe.defaultRecipes
}
