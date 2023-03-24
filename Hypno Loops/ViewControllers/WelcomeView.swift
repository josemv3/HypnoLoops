//
//  WelcomeController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/19/23.
//

import UIKit
import Firebase

class WelcomeView: UIViewController {
    
    @IBOutlet weak var TopLogoView: UIImageView!
    @IBOutlet weak var userLoginButton: UIButton!
    @IBOutlet weak var userLoginImage: UIImageView!
    @IBOutlet weak var categoryViewButton: UIButton!
    @IBOutlet weak var recordingViewButton: UIButton!
    @IBOutlet weak var playViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfileImageView()
        userLoginImage.layer.borderWidth = BorderSize.small.size
        userLoginImage.layer.cornerRadius = CornerRadiusModifiers.normal.size
        userLoginImage.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
    }
    
    func configureProfileImageView() {
        if let user = Auth.auth().currentUser {
            userLoginButton.isHidden = true
            let reference = Database.database().reference(fromURL: RealtimeDatabase.referenceURLString.rawValue)
            let userRef = reference.child("users").child(user.uid)
            
            userRef.observeSingleEvent(of: .value) { snapshot in
                let profilePhotoURL = snapshot.childSnapshot(forPath: "profilePhotoURL").value as! String
                let url = URL(string: profilePhotoURL)!
                
                URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                    guard let data = data else { return }
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.userLoginImage.image = image
                    }
                }.resume()
            }
            
        } else {
            print("logged out")
        }
    }
    
    @IBAction func categoryViewButtonPush(_ sender: UIButton) {
        performSegue(withIdentifier: SegueID.gotoCategoryView.rawValue, sender: self)
    }
    
    @IBAction func recordingViewPushed(_ sender: UIButton) {
        performSegue(withIdentifier: SegueID.welcomToRecord.rawValue, sender: self)
    }
    
    @IBAction func playViewPushed(_ sender: UIButton) {
    }
    
}

//user logged in, userLogInButton = logOut
//then go to loginView

//
