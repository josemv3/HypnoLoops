//
//  UserProfileController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/19/23.
//

import UIKit

class UserProfileController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loopsPlayedLabel: UILabel!
    @IBOutlet weak var meditationLabel: UILabel!
    @IBOutlet weak var loopsPlayedNumberLabel: UILabel!
    @IBOutlet weak var meditationMinNumberLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoLoopCollections", sender: self)
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
