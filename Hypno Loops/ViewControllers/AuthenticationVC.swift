//
//  AuthenticationVC.swift
//  Hypno Loops
//
//  Created by Olijujuan Green on 5/26/23.
//

import UIKit
import FirebaseAuth

class AuthenticationVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    private var email = ""
    private var password = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateUser()
        configureTextFields()
        
        // Do any additional setup after loading the view.
    }
    
    func configureTextFields() {
        passwordTextField.isSecureTextEntry = true
        
    }
    
    func validate(text: String) throws {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        if (!capitalresult) {
            throw ValidationError.missingUppercase
        }
        
        let lowerLetterRegEx  = ".*[a-z]+.*"
        let lowerTest = NSPredicate(format:"SELF MATCHES %@", lowerLetterRegEx)
        let lowerresult = lowerTest.evaluate(with: text)
        if (!lowerresult) {
            throw ValidationError.missingLowercase
        }
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        if (!numberresult) {
            throw ValidationError.missingNumber
        }
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialresult = texttest2.evaluate(with: text)
        if (!specialresult) {
            throw ValidationError.missingSpecialCharacter
        }
    }
    
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        email = emailTextField.text!
        password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error as NSError? {
                print(error.localizedDescription)
                switch AuthErrorCode.Code(rawValue: error.code) {

                case .none:
                    print("noerrors")
                case .some(_):
                    self.showAlert(with: "Login Error", message: error.localizedDescription)
                }
            } else {
                let welcomVC = WelcomeView()
                welcomVC.modalPresentationStyle = .fullScreen
                self.present(welcomVC, animated: true)
            }
        }
    }
    
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func didTapCreateAccountButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    func validateUser() {
        if Auth.auth().currentUser != nil {
            let welcomeVC = WelcomeView()
            welcomeVC.modalPresentationStyle = .fullScreen
            self.present(welcomeVC, animated: false)
        }
    }
}

extension AuthenticationVC : UITextFieldDelegate {
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        do {
            try validate(text: text)
        } catch {
            print(error)
        }
    }
}



enum ValidationError: Error, LocalizedError {
    case missingUppercase
    case missingLowercase
    case missingNumber
    case missingSpecialCharacter
    
    var errorDescription: String? {
        switch self {
        case .missingUppercase:
            return "You need at least one uppercase letter."
        case .missingLowercase:
            return "You need at least one lowercase letter."
        case .missingNumber:
            return "You need at least one number."
        case .missingSpecialCharacter:
            return "You need at least one special character."
        }
    }
}
