//
//  LatestNewsTableViewController.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 11/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LatestNewsTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsCollection.shared.latestNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! LatestNewsCell
        cell.link = self
        let news = NewsCollection.shared.latestNews[(indexPath as NSIndexPath).row]

        cell.label.text = news.title
        cell.cellImage.image = #imageLiteral(resourceName: "placeholder")
        if news.thumbnailUrl != nil {
            cell.activityIndicator.startAnimating()
            
            APIClient.shared.downloadImage(imageUrl: news.thumbnailUrl!) {
                (image, error) in
                guard error == nil else {
                    cell.activityIndicator.stopAnimating()
                    return
                }
                DispatchQueue.main.async {
                    cell.cellImage.image = UIImage(data: image!)
                    cell.activityIndicator.stopAnimating()
                }
            }
        }
        cell.accessoryView?.tintColor = news.isFavorite ? self.view.tintColor : UIColor.lightGray
        return cell
    }
    
    // MARK: Action on Cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = NewsCollection.shared.latestNews[(indexPath as NSIndexPath).row].webUrl
        openUrl(urlString: url)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // add news to favorites
    func addFavorite(cell: UITableViewCell) {
        
        // get tapped cell index
        let TappedCellIndex = tableView.indexPath(for: cell)
        
        // get news
        let news = NewsCollection.shared.latestNews[(TappedCellIndex!.row)]
        NewsCollection.shared.latestNews[(TappedCellIndex!.row)].isFavorite = !news.isFavorite
        
        // mark favorite
        if (!news.isFavorite) {
            let data = [Constants.GuardianResponseKeys.Title: news.title as String,
                        Constants.GuardianResponseKeys.WebUrl: news.webUrl as String,
                        Constants.GuardianResponseKeys.Thumbnail: news.thumbnailUrl ?? ""]
            
            // add to firebase database
            ref.child("news").childByAutoId().setValue(data)
        }
        
        // relaod the table view
        tableView.reloadRows(at: [TappedCellIndex!], with: .automatic)
    }
    
    // MARK: Reload table data
    func reloadData() {
        self.tableView.reloadData()
    }
}