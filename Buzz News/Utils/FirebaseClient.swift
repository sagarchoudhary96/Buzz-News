//
//  FirebaseClient.swift
//  Buzz News
//
//  Created by Sagar Choudhary on 17/12/18.
//  Copyright © 2018 Sagar Choudhary. All rights reserved.
//

import Firebase
class FirebaseClient {
    let ref = Database.database().reference()
    // shared singleton firebase instance
    static let shared = FirebaseClient()

    // MARK: add to firebase
    func addToFirebase(userId: String, data : [String: String]) {
        
        // add observer
        ref.child("news/\(userId)").queryOrdered(byChild: "webUrl").queryEqual(toValue: data[Constants.GuardianResponseKeys.WebUrl]).observe(.value) {
            (snapshot: DataSnapshot) in
            
            // if the news is not already in favorite
            if !snapshot.exists()  {
                self.ref.child("news/\(userId)").childByAutoId().setValue(data)
            }
        }
        
        // remove observer
        self.ref.child("news/\(userId)").queryOrdered(byChild: "webUrl").queryEqual(toValue: data[Constants.GuardianResponseKeys.WebUrl]).removeAllObservers()
    }
    
    // MARK: remove from firebase
    func removeFromFirebase(userId: String, key : String) {
        ref.child("news/\(userId)").child(key).removeValue()
    }
}
