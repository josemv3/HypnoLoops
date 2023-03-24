//
//  NetworkManager.swift
//  Hypno Loops
//
//  Created by Olijujuan Green on 3/23/23.
//

import Foundation
import UIKit
import Firebase

class NetworkManager {
    private init () {}
    static let shared = NetworkManager()
    
    func fetchUserProfileImage(user: User) -> UIImage {
        var image = UIImage()
        let usersRef = Database.database().reference(fromURL: RealtimeDatabase.referenceURLString.rawValue).child("users").child(user.uid)
        
        usersRef.observeSingleEvent(of: .value) { snapshot in
            let profilePhotoURL = snapshot.childSnapshot(forPath: "profilePhotoURL").value as! String
            
            let url = URL(string: profilePhotoURL)!
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if error != nil { return }
                guard let data = data else { return }
                image = UIImage(data: data)!
            }
            task.resume()
        }
        
        return image
    }
    
}
