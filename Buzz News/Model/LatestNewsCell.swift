//
//  LatestNewsCell.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 11/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

// MARK: Latest News Table cell
class LatestNewsCell : UITableViewCell {
    
    var link: LatestNewsTableViewController?
    
    // MARK: Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // favorite button handler
    @objc private func handleFavorite() {
        link?.addFavorite(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        let starButton = UIButton(type: .system)
        starButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        starButton.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        accessoryView = starButton
        textLabel?.numberOfLines = 2
    }
}
