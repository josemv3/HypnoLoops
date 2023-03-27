//
//  NetworkManager.swift
//  Hypno Loops
//
//  Created by Olijujuan Green on 3/23/23.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


class NetworkManager {
    private init () {}
    static let shared = NetworkManager()
    
    func fetchUserProfileImage(completion: @escaping (URL?) -> Void) {
        if let user = Auth.auth().currentUser {
            let reference = Database.database().reference(fromURL: RealtimeDatabase.referenceURLString.rawValue)
            let userRef = reference.child("users").child(user.uid)
            
            userRef.observeSingleEvent(of: .value) { snapshot in
                let profilePhotoURL = snapshot.childSnapshot(forPath: "profilePhotoURL").value as? String
                let url = URL(string: profilePhotoURL ?? "")
                completion(url)
            }
        } else {
            completion(nil)
        }
    }

    
    
    
    
    
    
    
    
}
