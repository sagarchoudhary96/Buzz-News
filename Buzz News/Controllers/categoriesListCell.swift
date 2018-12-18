//
//  categoriesListCell.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 13/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

// MARK: Categories List Table Cell
class categoriesListCell: UITableViewCell {
    
    var category: String!
    
    var link: CategoriesTableViewController!
    var userId: String!
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: fetch each categories news
    func fetchSectionNews() {
        // create request
        let request = APIClient.shared.createRequest(requestType: .Category, section: self.category.lowercased())
    
        self.activityIndicator.startAnimating()
        
        //make request
        APIClient.shared.makeRequest(request: request) {
            (result, error) in
            
            // guard for the error
            guard error == nil else {
                self.link.showAlertMessage(message: "\(error!) : \(self.category!)")
                self.activityIndicator.stop()
                return
            }
            
            // create news list
            let newsList: NSMutableArray = NSMutableArray()
            for news in result! {
                newsList.add(News(newsDict: news as! [String : AnyObject]))
            }
            
            // add to the datasource, i.e: News Collection
            NewsCollection.shared.categoryNews[self.category] = newsList
            self.activityIndicator.stop()
            
            // reload views
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARk: add news to Favorites
    func addFavorite(cell: categoryNewsCell) {
        
        // get reference to tapped table cell
        let TappedCellIndex = collectionView.indexPath(for: cell)
        
        // get news reference
        var news = NewsCollection.shared.categoryNews[category]![(TappedCellIndex?.row)!] as! News
        news.isFavorite = !news.isFavorite
        
        // update the tapped news object
        NewsCollection.shared.categoryNews[category]!.removeObject(at: (TappedCellIndex?.row)!)
        NewsCollection.shared.categoryNews[category]!.insert(news, at: (TappedCellIndex?.row)!)
        
        // if news is favorited
        if (news.isFavorite) {
            let data = [Constants.GuardianResponseKeys.Title: news.title as String,
                        Constants.GuardianResponseKeys.WebUrl: news.webUrl as String,
                        Constants.GuardianResponseKeys.Thumbnail: news.thumbnailUrl ?? ""]
            
                // add to in-memory list
            NewsCollection.shared.favoriteList.append(news.webUrl)
            
            // add to the firebase database
            FirebaseClient.shared.addToFirebase(userId: userId, data: data)
        } else {
            // add to in-memory list
            print("here")
            if NewsCollection.shared.favoriteList.contains(news.webUrl) {
                let index = NewsCollection.shared.favoriteList.firstIndex(of: news.webUrl)
                NewsCollection.shared.favoriteList.remove(at: index!)
            }
        }
        
        // reload collection view
        collectionView.reloadItems(at: [TappedCellIndex!])
    }
}

// MARK: Collection View Delegate Methods
extension categoriesListCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // cell at each index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // reusable cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryNewsCell", for: indexPath) as! categoryNewsCell
       
        // get news
        var news = NewsCollection.shared.categoryNews[category]![indexPath.row] as! News
        
        // set initial values
        cell.title.text = news.title
        cell.cellImage.image = #imageLiteral(resourceName: "placeholder")
        cell.link = self
        let image = UIImage(named: "fav_star")?.withRenderingMode(.alwaysTemplate)
        cell.favoriteButton.setImage(image, for: .normal)
        
        // if url is present
        if news.thumbnailUrl != nil {
            cell.activityIndicator.startAnimating()
            
            // download image for each cell
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
        
        news.isFavorite = NewsCollection.shared.favoriteList.contains(news.webUrl) ? true : false
        
        NewsCollection.shared.categoryNews[category]!.removeObject(at: indexPath.row)
        NewsCollection.shared.categoryNews[category]!.insert(news, at: indexPath.row)

        // set button color
        cell.favoriteButton.tintColor = news.isFavorite ? self.link.view.tintColor : UIColor.lightGray
        
        return cell
    }
    
    // number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NewsCollection.shared.categoryNews[category]?.count ?? 0
    }
    
    // on tap of collection cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = (NewsCollection.shared.categoryNews[category]?[indexPath.row] as! News).webUrl
        self.link.openUrl(urlString: url)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
