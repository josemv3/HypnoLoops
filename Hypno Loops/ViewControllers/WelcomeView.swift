//
//  WelcomeController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/19/23.
//

import UIKit

class WelcomeView: UIViewController {

    @IBOutlet weak var TopLogoView: UIImageView!
    @IBOutlet weak var userLoginButton: UIButton!
    @IBOutlet weak var userLoginImage: UIImageView!
    @IBOutlet weak var categoryViewButton: UIButton!
    @IBOutlet weak var recordingViewButton: UIButton!
    @IBOutlet weak var playViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLoginImage.layer.borderWidth = BorderSize.small.size
        userLoginImage.layer.cornerRadius = CornerRadiusModifiers.normal.size
        userLoginImage.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
    }
    
    @IBAction func categoryViewButtonPush(_ sender: UIButton) {
        performSegue(withIdentifier: SegueID.gotoCategoryView.rawValue, sender: self)
    }
    
}

//user logged in, userLogInButton = logOut
//then go to loginView

//
