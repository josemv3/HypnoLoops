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
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HERE --->>>", Auth.auth().currentUser?.displayName)
//        NetworkManager.shared.getCurrentUserData()
//        configureProfileImageView()
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
    
    @IBAction func playViewButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueID.gotoPlay.rawValue, sender: self)
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
        
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case SegueID.welcomeToLoginView.rawValue:
//            let logInView = segue.destination as! LogInView
//        case SegueID.gotoProfile.rawValue:
//            let userProfileView =  segue.destination as! UserProfileView
//        case SegueID.gotoCategoryView.rawValue:
//            let categoryView = segue.destination as! CategoryView
//            //categoryView.userData = NetworkManager.userData
//        case SegueID.welcomToRecord.rawValue:
//            let recordView = segue.destination as! RecordView
////        case SegueID.gotoPlay.rawValue:
////            let playView = segue.destination as! PlayView
//        default:
//            print("Error in WelcomView segue")
//        }
//    }
}
