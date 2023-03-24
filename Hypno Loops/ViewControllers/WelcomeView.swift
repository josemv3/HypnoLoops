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
    
<<<<<<< HEAD
    @IBAction func userLoginButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: SegueID.welcomeToLoginView.rawValue, sender: self)
    }
    
=======
>>>>>>> f8455911def8181facaba5718942e7a0a0c425a6
    @IBAction func categoryViewButtonPush(_ sender: UIButton) {
        performSegue(withIdentifier: SegueID.gotoCategoryView.rawValue, sender: self)
    }
    
    @IBAction func recordingViewPushed(_ sender: UIButton) {
        performSegue(withIdentifier: SegueID.welcomToRecord.rawValue, sender: self)
    }
    
    @IBAction func playViewPushed(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueID.welcomeToLoginView.rawValue {
            let destinationVC = segue.destination as! LogInView
        }
        
        switch segue.identifier {
        case SegueID.welcomeToLoginView.rawValue:
            let logInView = segue.destination as! LogInView
            //logInView.emailErrorLabel
            //use loginView.?? to access any property or function in LogInView
        case SegueID.gotoProfile.rawValue:
            let userProfileView =  segue.destination as! UserProfileView
        case SegueID.gotoCategoryView.rawValue:
            let categoryView = segue.destination as! CategoryView
        case SegueID.welcomToRecord.rawValue:
            let recordView = segue.destination as! RecordView
        default:
            print("Error in WelcomView segue")
        }
    }
}

//user logged in, userLogInButton = logOut
//then go to loginView

//
