//
//  Constants.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 11/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Foundation
struct Constants {
    
    struct Guardian {
        static let APIScheme = "https"
        static let APIHost = "content.guardianapis.com"
        static let APIBaseURL = "/search"
    }
    
    struct GuardianParamNames {
        static let APIKey = "api-key"
        static let PageSize = "page-size"
        static let Fields = "show-fields"
        static let Section = "section"
    }
    
    struct GuardianParamValues {
        static let APIKey =  "GUARDIAN_API_KEY_HERE"
        static let PageSize = "30"
        static let FieldThumbnail = "thumbnail"
    }
    
    struct GuardianResponseKeys {
        static let Response = "response"
        static let Results = "results"
        static let Title = "webTitle"
        static let WebUrl = "webUrl"
        static let ShowField = "fields"
        static let Thumbnail = "thumbnail"
        static let SectionId = "sectionId"
    }
    
}
