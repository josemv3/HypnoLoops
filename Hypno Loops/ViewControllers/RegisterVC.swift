//
//  RegisterVC.swift
//  Hypno Loops
//
//  Created by Olijujuan Green on 5/27/23.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    
    private var username = ""
    private var email = ""
    private var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }
    
    
    func configureTextFields() {
        let imgButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgButton.addTarget(self, action: #selector(togglePrivateTextEntry), for: .touchUpInside)
        let img = UIImage(systemName: "eye.slash")
        imgButton.setImage(img, for: .normal)
        let padding: CGFloat = 8
        let paddingWidth = imgButton.frame.width + padding
        let paddingHeight = imgButton.frame.height
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: paddingHeight))
        paddingView.addSubview(imgButton)
        passwordTextField.rightView = paddingView
        passwordTextField.rightViewMode = .always
        passwordTextField.isSecureTextEntry = true
    }
    
    
    @objc func togglePrivateTextEntry(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction func didTapPhotoButton(_ sender: Any) {
    }
    
    @IBAction func didTapSignupButton(_ sender: Any) {
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // User creation successful, now set display name
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = username
                changeRequest.commitChanges { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Display name updated successfully!")
                        
                        self.performSegue(withIdentifier: "presentWelcomeView", sender: self)
                    }
                }
            }
        }
    }

    
}
