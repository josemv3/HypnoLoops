//
//  ViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/16/23.
//

import UIKit

class CreateAccountController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var submitButtton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetForm()
    }
    
    func resetForm() {
        usernameErrorLabel.isHidden = false
        emailErrorLabel.isHidden = false
        passwordErrorLabel.isHidden = false
       
        usernameErrorLabel.text = "Required"
        emailErrorLabel.text = "Required"
        passwordErrorLabel.text = "Required"
        
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        resetForm()
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
            return "Username must have at least 3 characters"
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
            return "Invalid Email Address"
        }
        return nil
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
            return "Password must be at least 8 characters"
        }
        if containsDigit(value) {
            return "Password must conttain at least 1 digit"
        }
        if containsLowercase(value) {
            return "Password must contain at least 1 lowercase letter"
        }
        if containsUppercase(value) {
            return "Password must contain at least 1 uppercase letter"
        }
        return nil
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
        if usernameErrorLabel.isHidden && emailErrorLabel.isHidden && passwordErrorLabel.isHidden {
            submitButtton.isEnabled =  true
        } else {
            submitButtton.isEnabled = false
        }
    }
    
    //MARK: - Seque
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoProfile" {
            let destinationVC = segue.destination as! UserProfileController
        }
    }
}

