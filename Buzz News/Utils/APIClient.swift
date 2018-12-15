//
//  APIClient.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 11/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Foundation
class APIClient {
    
    let session = URLSession.shared
    
    // shared singleton api instance
    static let shared = APIClient()
    
    // MARK: Request Methods
    enum requestType: String {
        case Latest
        case Category
    }

    // MARK: Build Url from params
    private func buildUrlWithParam(parameters: [String: AnyObject]) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Guardian.APIScheme
        urlComponents.host = Constants.Guardian.APIHost
        urlComponents.path = Constants.Guardian.APIBaseURL
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems!.append(queryItem)
        }
        print("\(urlComponents.url!)")
        return urlComponents.url!
    }
    
    private func newsParam() -> Dictionary<String, Any> {
        return [
            Constants.GuardianParamNames.APIKey: Constants.GuardianParamValues.APIKey,
            Constants.GuardianParamNames.PageSize: Constants.GuardianParamValues.PageSize,
            Constants.GuardianParamNames.Fields: Constants.GuardianParamValues.FieldThumbnail
        ]
    }
    
    // MARK: Create Request
    func createRequest(requestType: requestType, section: String?) -> URLRequest {
        var request: URLRequest
        switch requestType {
        case .Latest:
            request = URLRequest(url: buildUrlWithParam(parameters: newsParam() as [String : AnyObject]))
            break
        case .Category:
            var params = newsParam() as [String: AnyObject]
            params[Constants.GuardianParamNames.Section] = section as AnyObject
            request = URLRequest(url: buildUrlWithParam(parameters: params))
            break
        }
        return request
    }
    
    
    // MARK: Make Request
    func makeRequest(request: URLRequest, completionHandler: @escaping (_ result: NSArray?, _ error: String?) -> Void) {
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // guard for error
            guard(error == nil) else {
                completionHandler(nil, "Connection Error")
                return
            }
            
            // guard for successful http response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil, "Your request returned a status code other than 2xx!")
                return
            }
            
            // guard if any data is returned or not
            guard let data = data else {
                completionHandler(nil, "No data was returned by the API")
                return
            }
            
            // parse the result
            let parsedResult: [String: AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            } catch {
                completionHandler(nil, "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            // guard if response and results key are present
            guard let response = parsedResult?[Constants.GuardianResponseKeys.Response] as? [String: AnyObject], let resultsArray = response[Constants.GuardianResponseKeys.Results] as? [[String: AnyObject]] else {
                completionHandler(nil, "Cannot find \(Constants.GuardianResponseKeys.Response) key in \(parsedResult!)")
                return
            }
            
            // guard if news are present
            guard resultsArray.count > 0 else {
                completionHandler(nil, "No News Found! Try again")
                return
            }
            
            
            // Yay! we got the news
            completionHandler(resultsArray as NSArray, nil)
        }
        task.resume()
    }
    
    
    //MARK: Download Image
    func downloadImage(imageUrl: String, completionHandler: @escaping (_ image: Data?,_ error: String?) -> Void ) {
        let task = session.dataTask(with: URL(string: imageUrl)!) {
            (data, response, error) in
            
            // guard for error
            guard(error == nil) else {
                completionHandler(nil, "Connection Error")
                return
            }
            
            // guard for successful http response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil, "Your request returned a status code other than 2xx!")
                return
            }
            
            // yay! we got the image
            completionHandler(data, nil)
            
        }
        task.resume()
    }
}
