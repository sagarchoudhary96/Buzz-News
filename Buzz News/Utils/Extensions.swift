//
//  Extensions.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 10/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit
//MARK: Extensions
public extension UIViewController {
    
    // show alert message
    func showAlertMessage(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // open url in browser
    func openUrl(urlString : String) {
        if let url = URL(string: urlString) {
            if (UIApplication.shared.canOpenURL(url)) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                showAlertMessage(message: "Cannot Open URL: \(urlString)")
            }
        }
    }
}


// MARK: Button Extension
extension UIView {
    
    func roundCorners(radius: CGFloat = 4) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
}

// MARK: ActivityIndicator Extension
extension UIActivityIndicatorView {
    func stop() {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }
}
