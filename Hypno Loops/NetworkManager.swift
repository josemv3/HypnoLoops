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
import FirebaseStorage


class NetworkManager {
    private init () {}
    static let shared = NetworkManager()
    
    public static var userData: UserData?
    
    //    func fetchUserProfileImageURL(photoURL: URL, context: completed: @escaping (Result<UIImage, Error>) -> Void) {
    //        guard let uid = Auth.auth().currentUser?.uid else { return }
    //        let storageRef = Storage.storage().reference().child("user/\(uid)")
    //        print("FULL PATH --->>>", storageRef)
    //
    //        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
    //            if let error = error {
    //                completed(.failure(error))
    //            } else {
    //                let image = UIImage(data: data!)
    //                completed(.success(image!))
    //            }
    //        }
    //    }
    
    func fetchUserProfileImageURL(imageView: UIImageView) {
        let storageRef = Storage.storage().reference().child("users").child(Auth.auth().currentUser!.uid).child("profile.jpg")
        
        let url = storageRef.downloadURL { url, error in
            if let error = error {
                print(error)
            } else {
                URLSession.shared.dataTask(with: url!) { data, _, _ in
                    guard let data = data else { return }
                    guard let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }.resume()
                
            }
        }
        
        
        
    }
    
    func getCurrentUserData() {
        if let user = Auth.auth().currentUser {
            let reference = Database.database().reference()
            let userRef = reference.child("users").child(user.uid).child("likedAffirmations")
            
            userRef.getData { error, snapshot in
                let likedAffirmationIds = snapshot?.value as? [String] ?? []
                //completion(.success(UserData(username: user.displayName!, likedAffirmationIds: likedAffirmationIds)))
                 NetworkManager.userData = UserData(username: user.displayName!, likedAffirmationIds: likedAffirmationIds)
            }
        }
    }
    
    //    func getCurrentUserData() -> Task<UserData, Error> {
    //        Task { [weak self] in
    //            guard let self = self, let user = Auth.auth().currentUser else {
    //                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])
    //            }
    //            let reference = Database.database().reference()
    //            let userRef = reference.child("users").child(user.uid).child("likedAffirmations")
    //            do {
    //                let data = try await userRef.getData()
    //                let likedAffirmationIds = data.value as? [String] ?? []
    //                return UserData(username: user.displayName!, likedAffirmationIds: likedAffirmationIds)
    //            } catch {
    //                throw error
    //            }
    //        }
    //    }
    
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
    
    func updateLikedAffirmations(likedAffirmationIds: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let reference = Database.database().reference()
        let affirmationIds = reference.child("users").child(uid).child("likedAffirmations")
        
        affirmationIds.setValue(likedAffirmationIds) { (error, ref) in
            if let _ = error {
                print("failed to update like affirmations")
            } else {
                print("updated successfully")
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
