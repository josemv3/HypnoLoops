//
//  WelcomeController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/19/23.
//

import UIKit
import Firebase
import FirebaseStorage

class WelcomeView: UIViewController {
    
    @IBOutlet weak var TopLogoView: UIImageView!
    @IBOutlet weak var userLoginImage: UIImageView!
    @IBOutlet weak var categoryViewButton: UIButton!
    @IBOutlet weak var recordingViewButton: UIButton!
    @IBOutlet weak var playViewButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logout", style: .done, target: self, action: #selector(logout))
//        NetworkManager.shared.getCurrentUserData()
//        configureProfileImageView()
//        userLoginImage.layer.borderWidth = BorderSize.small.size
//        userLoginImage.layer.cornerRadius = CornerRadiusModifiers.normal.size
//        userLoginImage.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
    
    func configureProfileImageView() {
        if let _ = Auth.auth().currentUser {
            NetworkManager.shared.fetchUserProfileImageURL(imageView: userLoginImage)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueID.welcomeToLoginView.rawValue:
            let logInView = segue.destination as! LogInView
            //logInView.emailErrorLabel
            //use loginView.?? to access any property or function in LogInView
        case SegueID.gotoProfile.rawValue:
            let userProfileView =  segue.destination as! UserProfileView
        case SegueID.gotoCategoryView.rawValue:
            let categoryView = segue.destination as! CategoryView
            //categoryView.userData = NetworkManager.userData
        case SegueID.welcomToRecord.rawValue:
            let recordView = segue.destination as! RecordView
        default:
            print("Error in WelcomView segue")
        }
    }
}
