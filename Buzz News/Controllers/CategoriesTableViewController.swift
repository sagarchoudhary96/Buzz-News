//
//  CategoriesTableViewController.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 13/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    // MARK: Categories section
    var categories = ["Sport", "Media", "Politics", "Travel"]
    var userID: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = (UserDefaults.standard.value(forKey: "userId") as! String)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesListCell") as! categoriesListCell
        cell.category = categories[indexPath.section]
        cell.link = self
        cell.userId = userID
        cell.fetchSectionNews()
        return cell
    }
    
    // MARK: Reload table data
    func reloadData() {
        self.tableView.reloadData()
    }

}
