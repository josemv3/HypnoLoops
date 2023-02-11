//
//  UserProfileController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/19/23.
//

import UIKit
import FirebaseAuth

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

        getUserInfo()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.cornerRadius = CornerRadiusModifiers.normal.size
        profileImageView.layer.borderColor = UIColor.darkGray.cgColor
        //profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.size.width
    }
    
    @IBAction func changeProfileImageButtonPushed(_ sender: UIButton) {
        presentPhotoActionSheet()
    }
    
    @IBAction func doneButtonPushed(_ sender: UIButton) {
        performSegue(withIdentifier: SegueID.gotoLoopCollections.rawValue, sender: self)
    }
}

extension UserProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        profileImageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func getUserInfo() {
        //usernameTextField.placeholder = 
        emailTextField.text = FirebaseAuth.Auth.auth().currentUser?.email
    }
}
