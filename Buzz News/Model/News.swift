//
//  News.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 11/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Foundation

//MARK: News
struct News {
    var title = ""
    var webUrl = ""
    var thumbnailUrl:String? = nil
    var category = ""
    var isFavorite:Bool = false
    init() {
        return
    }
    
    init(newsDict: [String: AnyObject]) {
        title = newsDict[Constants.GuardianResponseKeys.Title] as? String ?? ""
        webUrl = newsDict[Constants.GuardianResponseKeys.WebUrl] as? String ?? ""
        category = newsDict[Constants.GuardianResponseKeys.SectionId] as? String ?? ""

        
        guard let fields = newsDict[Constants.GuardianResponseKeys.ShowField] as? [String: AnyObject], let thumbnail = fields[Constants.GuardianResponseKeys.Thumbnail] as? String else {
            return
        }
        thumbnailUrl = thumbnail
    }
}
