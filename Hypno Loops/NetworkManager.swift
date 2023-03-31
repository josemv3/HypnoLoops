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
    
    func fetchUserProfileImageURL(photoURLString: String, imageView: UIImageView) {
        guard let photoURL = URL(string: photoURLString) else { return }
        
        URLSession.shared.dataTask(with: photoURL) { data, _, _ in
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
        
    }
    
    func getCurrentUserData(completion: @escaping (Result<UserData, Error>) -> Void) {
        if let user = Auth.auth().currentUser {
            let reference = Database.database().reference(fromURL: RealtimeDatabase.referenceURLString.rawValue)
            let userRef = reference.child("users").child(user.uid)
            
            userRef.observeSingleEvent(of: .value) { snapshot in
                let urlString = snapshot.childSnapshot(forPath: "profilePhotoURL").value as! String
                let username = snapshot.childSnapshot(forPath: "username").value as! String
                completion(.success(UserData(username: username, imageURL: urlString)))
            }
        }
        
    }
    
    func parseJSONData(completed: @escaping (Result<[CategoryModel], Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "Affirmations", withExtension: "json") {
            do {
                let decoder = JSONDecoder()
                let data = try Data(contentsOf: url)
                let categories = try decoder.decode([CategoryModel].self, from: data)
                completed(.success(categories))
            } catch {
                completed(.failure(error))
            }
        }
    }

    
    
    
    
    
    
    
    
}
