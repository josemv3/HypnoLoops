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
    var isLoggedIn = Auth.auth().currentUser == nil
    //var userData = NetworkManager.userData
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if Auth.auth().currentUser != nil { print("USER FOUND: ", Auth.auth().currentUser) }
        configureProfile()
        userLoginImage.layer.borderWidth = BorderSize.small.size
        userLoginImage.layer.cornerRadius = CornerRadiusModifiers.normal.size
        userLoginImage.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
        //print("UserData HERE >", NetworkManager.userData)
    }
    
    func configureProfile() {
        NetworkManager.shared.getCurrentUserData { result in
            switch result {
            case .success(let userData):
                NetworkManager.userData = userData
                NetworkManager.shared.fetchUserProfileImageURL(photoURL: (Auth.auth().currentUser?.photoURL)!, imageView: self.userLoginImage)
                print("USER DATA HERE ->", userData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUserData() {
        if let user = Auth.auth().currentUser {
            print("Inside getUserData")
            NetworkManager.shared.getCurrentUserData { result in
                switch result {
                case .success(let userData):
                    print("inside user data", userData)
                    NetworkManager.userData = userData
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
//    func getUserData() async {
//        if let user = Auth.auth().currentUser {
//            do {
//                let task = NetworkManager.shared.getCurrentUserData()
//                let userData = try await task.value
//                NetworkManager.userData = userData
//                configureProfileImageView()
//            } catch {
//                print(error)
//            }
//        }
//    }
        
        
        @IBAction func userLoginButtonPushed(_ sender: UIButton) {
            performSegue(withIdentifier: SegueID.welcomeToLoginView.rawValue, sender: self)
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
            //        if segue.identifier == SegueID.welcomeToLoginView.rawValue {
            //            let destinationVC = segue.destination as! LogInView
            //        }
            
            switch segue.identifier {
            case SegueID.welcomeToLoginView.rawValue:
                let logInView = segue.destination as! LogInView
                //logInView.emailErrorLabel
                //use loginView.?? to access any property or function in LogInView
            case SegueID.gotoProfile.rawValue:
                let userProfileView =  segue.destination as! UserProfileView
            case SegueID.gotoCategoryView.rawValue:
                let categoryView = segue.destination as! CategoryView
                categoryView.userData = NetworkManager.userData
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

