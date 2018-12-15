//
//  ViewController.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 10/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class LoginViewController: UIViewController {
    
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var authUI: FUIAuth!
    
    // MARK: Outlets
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        // custom button styles
        loginButton.roundCorners()
        
        configureAuth()
    }
    
    // MARK: configure firebase auth
    fileprivate func configureAuth() {
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
        _authHandle = Auth.auth().addStateDidChangeListener {
            (auth: Auth, user: User?) in
            
            
            if let activeUser = user {
                if self.user != activeUser {
                    self.user = activeUser
                    self.performSegue(withIdentifier: "mainScreen", sender: self)
                }
            }
        }
    }
    
    // present login session view
    func loginSession() {
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    // MARK: Signin user
    @IBAction func sigin(_ sender: Any) {
        loginSession()
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(_authHandle)
    }
}

// MARK: Firebase Auth Delegate method
extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard  error == nil else {
            self.showAlertMessage(message: "Unable to Login : \(error!.localizedDescription)")
            return
        }
        
        self.performSegue(withIdentifier: "mainScreen", sender: self)
    }
}

