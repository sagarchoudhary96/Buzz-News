//
//  LatestNewsTableViewController.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 11/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

class LatestNewsTableViewController: UITableViewController {
    
    var userID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = (UserDefaults.standard.value(forKey: "userId") as! String)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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

        NewsCollection.shared.latestNews[(indexPath as NSIndexPath).row].isFavorite =  NewsCollection.shared.favoriteList.contains(news.webUrl) ? true : false
        
        cell.accessoryView?.tintColor = NewsCollection.shared.favoriteList.contains(news.webUrl) ? self.view.tintColor : UIColor.lightGray
        
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
            
            // add to in-memory list
            NewsCollection.shared.favoriteList.append(news.webUrl)
            
            // add to firebase database
            FirebaseClient.shared.addToFirebase(userId: userID!, data: data)
        } else {
           // remove from in-memory list
            if NewsCollection.shared.favoriteList.contains(news.webUrl) {
                let index = NewsCollection.shared.favoriteList.firstIndex(of: news.webUrl)
                NewsCollection.shared.favoriteList.remove(at: index!)
            }
            
        }
        
        // relaod the table view
        tableView.reloadRows(at: [TappedCellIndex!], with: .automatic)
    }
    
    // MARK: Reload table data
    func reloadData() {
        self.tableView.reloadData()
    }
}
