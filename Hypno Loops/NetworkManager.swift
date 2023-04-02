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
    
    public static var userData: UserData?
    
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
            let reference = Database.database().reference()
            let userRef = reference.child("users").child(user.uid).child("likedAffirmations")
            
            userRef.getData { data, error in
                let likedAffirmationIds = data.value as! [String] ?? []
                completion(.success(UserData(username: Auth.auth().currentUser.displayName, likedAffirmationIds: likedAffirmationIds)))
            }
        }
    }
    
    func getSectionHeaders(completed: @escaping (Result<[SectionHeaderModel], Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "Affirmations", withExtension: "json") {
            do {
                let decoder = JSONDecoder()
                let data = try Data(contentsOf: url)
                let headers = try decoder.decode([SectionHeaderModel].self, from: data)
                completed(.success(headers))
            } catch {
                completed(.failure(error))
            }
        }
    }
    
    func updateLikedAffirmations(userAffirmationIDs: [String]) {
        print("inside")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Database.database().reference()
        let affirmationIds = reference.child("users").child(uid).child("likedAffirmations")
        print(affirmationIds)
        
        affirmationIds.setValue(userAffirmationIDs) { (error, ref) in
            if let _ = error {
                print("failed to update like affirmations")
            } else {
                print("updated successfully")
            }
        }
    }

    
    
    
    
    
    
    
    
}
