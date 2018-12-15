//
//  categoryNewsCell.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 13/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

// MARK: Category news cell
class categoryNewsCell: UICollectionViewCell {
    
    var link: categoriesListCell!
    
    // MARK: Outlets
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    // MARK: Actions
    @IBAction func markFavorite(_ sender: Any) {
        link.addFavorite(cell: self)
    }
    
}
