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
        ref.child("news/\(userId)").childByAutoId().setValue(data)
    }
    
    // MARK: remove from firebase
    func removeFromFirebase(userId: String, key : String) {
        ref.child("news/\(userId)").child(key).removeValue()
    }
}
