//
//  FavoriteNewsCell.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 12/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit

// MARK: Favorite News Table Cell
class FavoriteNewsCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
