//
//  ViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/16/23.
//

import UIKit
import Firebase
import FirebaseStorage



class LogInView: UIViewController {
    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var submitButtton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    enum requiredText: String {
        case Required, Success
    }
    
    //    private var userNameAdded: String? {
    //    }
    
    //private var userNameAdded: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetForm()
        passwordTextField.isSecureTextEntry = true
        profileView.layer.masksToBounds = true
        profileView.layer.borderWidth = BorderSize.small.size
        profileView.layer.cornerRadius = CornerRadiusModifiers.normal.size
        profileView.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
        profileButton.tintColor = UIColor(named: Color.hlBlue.rawValue)
    }
    
    func resetForm() {
        
        usernameErrorLabel.text = requiredText.Required.rawValue
        emailErrorLabel.text = requiredText.Required.rawValue
        passwordErrorLabel.text = requiredText.Required.rawValue
        
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        
        submitButtton.isEnabled = false
    }
    
    @IBAction func profileButtonPushed(_ sender: UIButton) {
        presentPhotoActionSheet()
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        //Get authorization Instance
        //Attempt signin
        //If failure alert popup to create account
        //Alert continue = create account
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                //strongSelf used in error to call func.show
                return
            }
            guard error == nil else {
                //Create user alert when guard error fails with .show
                //This means the info doesnt match an existing user so it cant sign in.
                //Instead, we create a user
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            //You are signed in here.. now what?
            //No reason to go to profile screen. Go to collections?
            //HideLabels in tutorial
            strongSelf.performSegue(withIdentifier: SegueID.loginToCategory.rawValue, sender: self)
            print("You have signed in")
        })
        //resetForm()
    }
    
func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account?", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {action in
            
            let auth = Auth.auth()
            auth.createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let strongSelf = self else { return }
                guard error == nil else {
                    print("Account creation failed")
                    return
                }
                
                guard result != nil else { return }
                guard let uid = result?.user.uid else { return }
                let databaseReference = Database.database().reference()
                
                //                MARK: handle profile pic
                let image = strongSelf.profileView.image!
                let imageData = image.jpegData(compressionQuality: 0.5)
                let storageReference = Storage.storage().reference().child("users/\(uid)/profile.jpg")
                storageReference.putData(imageData!)
                
                 
                
                if let user = auth.currentUser {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.photoURL = URL(string: storageReference.fullPath)
                    changeRequest.displayName = strongSelf.usernameTextField.text
                    changeRequest.commitChanges { error in
                        if error != nil {
                            print(error)
                        } else {
                            let userName = user.displayName
                            var likedAffirmations = [String]()
                            databaseReference.child("users").child(uid).likedAffirmations.getData { error, snapshot in
                                likedAffirmations = snapshot?.value as? [String] ?? []
                            }
                            NetworkManager.userData = UserData(username: userName!,likedAffirmationIds: likedAffirmations )
                            strongSelf.performSegue(withIdentifier: SegueID.gotoProfile.rawValue, sender: self)
                        }
                    }
                }
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: SegueID.gotoProfile.rawValue, sender: self)
    }
    
    //MARK: - Check Username
    
    @IBAction func usernameChanged(_ sender: UITextField) {
        if let username =  usernameTextField.text {
            //userNameAdded = username
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
        if value.count < 1 {
            usernameErrorLabel.textColor = UIColor.systemRed
            return ErrorMessage.invalidUsername.displayError
        }
        usernameErrorLabel.textColor = UIColor.systemGreen
        return requiredText.Success.rawValue
        //return nil
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
        if  emailErrorLabel.text == requiredText.Success.rawValue &&
                passwordErrorLabel.text == requiredText.Success.rawValue && usernameErrorLabel.text == requiredText.Success.rawValue {
            submitButtton.isEnabled =  true
        } else {
            submitButtton.isEnabled = false
        }
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueID.gotoProfile.rawValue {
            //let destinationVC = segue.destination as! UserProfileView
        }
    }
}

extension LogInView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile picture", message: "How would you like to select a profile photo", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Take photo", style: .default, handler: {[weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Chose photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true //Allows crop box
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        profileView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
