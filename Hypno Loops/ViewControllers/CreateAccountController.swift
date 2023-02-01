//
//  ViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/16/23.
//

import UIKit
import FirebaseAuth

class CreateAccountController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var submitButtton: UIButton!
    @IBOutlet weak var skipButton: UIButton!

    enum ErrorMessage {
        case invalidUsername, invalidEmail, invalidPassword_Count,
             invalidPassword_NeedDigit, invalidPassword_NeedUppercase,
             invalidPassword_NeedLowercase
        
        var displayError: String {
            switch self {
            case .invalidUsername:
                return "Username must have at least 3 characters"
            case .invalidEmail:
                return "Invalid Email Address"
            case .invalidPassword_Count:
                return "Password must be at least 8 characters"
            case .invalidPassword_NeedDigit:
                return "Password must conttain at least 1 digit"
            case .invalidPassword_NeedUppercase:
                return "Password must contain at least 1 uppercase letter"
            case .invalidPassword_NeedLowercase:
                return "Password must contain at least 1 lowercase letter"
            }
        }
    }
    
    enum requiredText: String {
        case Required, Success
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetForm()
        
        usernameTextField.isHidden = true
        usernameErrorLabel.isHidden = true
        passwordTextField.isSecureTextEntry = true
    }
    
    func resetForm() {
        //usernameErrorLabel.isHidden = false
        //emailErrorLabel.isHidden = false
        //passwordErrorLabel.isHidden = false
       
        usernameErrorLabel.text = requiredText.Required.rawValue
        emailErrorLabel.text = requiredText.Required.rawValue
        passwordErrorLabel.text = requiredText.Required.rawValue
        
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        
        submitButtton.isEnabled = false
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
                    
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            print("You have signed in")
        })
        //resetForm()
    }
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let strongSelf = self else {
                    return
                }
                
                guard error == nil else {
                    print("Account created")
                    return
                }
                print("You have signed in")
                //strongSelf.label
            }
        }))
        alert.addAction(UIAlertAction(title: "Canel", style: .cancel))
        
        present(alert, animated: true)
        
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoProfile", sender: self)
    }
    
    //MARK: - Check Username
    
    @IBAction func usernameChanged(_ sender: UITextField) {
        if let username =  usernameTextField.text {
            if let errorMessage = invalidUsername(username) {
                usernameErrorLabel.text = errorMessage
                usernameErrorLabel.isHidden = false
            } else {
                usernameErrorLabel.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func invalidUsername(_ value: String) -> String? {
        if value.count < 3 {
            return ErrorMessage.invalidUsername.displayError
        }
        return nil
    }
    
    //MARK: - Check Email
    
    @IBAction func emailChanged(_ sender: UITextField) {
      
        if let email = emailTextField.text {
            if let errorMessage = invalidEmail(email) {
                emailErrorLabel.text = errorMessage
                emailErrorLabel.isHidden = false
            } else {
                emailErrorLabel.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func invalidEmail(_ value: String) -> String? {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        if !predicate.evaluate(with: value) {
            emailErrorLabel.textColor = UIColor.systemRed
            return ErrorMessage.invalidEmail.displayError
        }
        emailErrorLabel.textColor = UIColor.systemGreen
        return requiredText.Success.rawValue
    }
    
    //MARK: - Check Password
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        if let password = passwordTextField.text {
            if let errorMessage = invalidPassword(password) {
                passwordErrorLabel.text = errorMessage
                passwordErrorLabel.isHidden = false
            } else {
                passwordErrorLabel.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func invalidPassword(_ value: String) -> String? {
        if value.count < 8 {
            passwordErrorLabel.textColor = UIColor.systemRed
            return ErrorMessage.invalidPassword_Count.displayError
        }
        if containsDigit(value) {
            passwordErrorLabel.textColor = UIColor.systemRed
            return ErrorMessage.invalidPassword_NeedDigit.displayError
        }
        if containsLowercase(value) {
            passwordErrorLabel.textColor = UIColor.systemRed
            return ErrorMessage.invalidPassword_NeedLowercase.displayError
        }
        if containsUppercase(value) {
            passwordErrorLabel.textColor = UIColor.systemRed
            return ErrorMessage.invalidPassword_NeedUppercase.displayError
        }
        passwordErrorLabel.textColor = UIColor.systemGreen
        return requiredText.Success.rawValue
    }
    
    func containsDigit(_ value: String) -> Bool {
        let regularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsLowercase(_ value: String) -> Bool {
        let regularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsUppercase(_ value: String) -> Bool {
        let regularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func checkForValidForm() {
        if  emailErrorLabel.text == requiredText.Success.rawValue && passwordErrorLabel.text == requiredText.Success.rawValue {
            submitButtton.isEnabled =  true
        } else {
            submitButtton.isEnabled = false
        }
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoProfile" {
            let destinationVC = segue.destination as! UserProfileController
        }
    }
}

