//
//  NewsCollection.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 11/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Foundation

// MARK: Class to store news
class NewsCollection {
    
    // latest news
    var latestNews = [News]()
    
    // categories news
    var categoryNews = [String:NSMutableArray]()
    
    // list to store favoriteURL to keep data consistent
    var favoriteList = [String]()
    
    // singleton shared instance
    static let shared = NewsCollection()
}
