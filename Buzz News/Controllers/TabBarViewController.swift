//
//  TabBarViewController.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 10/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController {
    
    var tabBarReference: UITabBarController!
    
    // MARK: Activity Indicator
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    enum tab: Int {
        case Latest = 0
        case Category
        case Favorites
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarReference = (navigationController?.topViewController as? UITabBarController)!

        // set activity indicator properties
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        activityIndicator.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.46)
        activityIndicator.center = view.center
        self.navigationController?.view.addSubview(activityIndicator)
        
        // fetch latest news
        reloadLatestNews()
    }
    
    // MARK: Set constraints to view
    override func viewWillLayoutSubviews() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController?.view.addConstraints(activityIndicatorConstraints())
    }
    
    
    // MARK: Signout the user
    @IBAction func signout(_ sender: Any) {
        // start loader
        self.activityIndicator.startAnimating()
        do {
            try Auth.auth().signOut()
            self.activityIndicator.stop()
            self.dismiss(animated: true, completion: nil)
        } catch {
            self.showAlertMessage(message: "unable to sign out: \(error)")
        }
    }
    
    // MARK: Reload News
    @IBAction func reloadNews(_ sender: Any?) {
        switch tabBarReference.selectedIndex {
        case tab.Latest.rawValue:
            reloadLatestNews()
            break
        case tab.Category.rawValue:
            (self.viewControllers![1] as! CategoriesTableViewController).reloadData()
            break
        default:
            break
        }
    }
    
    // reload latest news tab entries
    fileprivate func reloadLatestNews() {
        
        // create request
        let request = APIClient.shared.createRequest(requestType: .Latest, section: nil)
        
        self.activityIndicator.startAnimating()
        
        // Make request
        APIClient.shared.makeRequest(request: request) {
            (result, error) in
            
            // guard for the error
            guard error == nil else {
                self.showAlertMessage(message: error!)
                self.activityIndicator.stop()
                return
            }
            
            // create news list
            var newsList = [News]()
            for news in result! {
                newsList.append(News(newsDict: news as! [String : AnyObject]))
            }
            
            // update global latest news list
            NewsCollection.shared.latestNews = newsList
            self.activityIndicator.stop()
            DispatchQueue.main.async {
                (self.viewControllers![0] as! LatestNewsTableViewController).reloadData()
            }
        }
    }
}

// MARK: Activity Indicator Constraints
extension TabBarViewController {
    private func activityIndicatorConstraints() -> [NSLayoutConstraint] {
        let horizontalLeftConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .leading, relatedBy: .equal, toItem: self.navigationController?.view, attribute: .leading, multiplier: 1, constant: 0)
        let horizontalRightConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .trailing, relatedBy: .equal, toItem: self.navigationController?.view, attribute: .trailing, multiplier: 1, constant: 0)
        let centerXConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.navigationController?.view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.navigationController?.view, attribute: .centerY, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .bottom, relatedBy: .equal, toItem: self.navigationController?.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        return [horizontalLeftConstraint, horizontalRightConstraint, centerXConstraint, centerYConstraint, topConstraint, bottomConstraint]
    }
}
