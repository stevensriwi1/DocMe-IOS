//
//  authenticateController+handlers.swift
//  DocMe1
//
//  Created by Rachel Su Jia Xin on 2/2/20.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import FirebaseUI

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBAction func signUpTapped(_ sender: Any) {
        
        //Validate the fields
        let error = validateFields()
        
        //if there is an error, then display error to error label
        if error != nil{
            showError(error!)
        }
        else{
            
            //create cleaned versions of the data
            
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for errors
                if err != nil{
                    //There was an error creating the user
                    self.showError("Error creating user")
                }
                else{
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    //add a unique string
                    let imageName = NSUUID().uuidString
                    
                    // 1. save image
                    if let imageData = self.profPic!.image?.pngData(){
                        //add to storage the image with specific names
                        let storage = Storage.storage().reference().child("profile_images").child("\(imageName).png")
                         DispatchQueue.main.async {
                        storage.putData(imageData).observe(.success, handler: { (snapshot) in
                            storage.downloadURL(completion: { (url, error) in
                                if error != nil {
                                    print(error!.localizedDescription)
                                    return
                                }
                                if let profileImageUrl = url?.absoluteString {
                                guard let uid = (Auth.auth().currentUser?.uid) else {return}
                                let values = ["firstname": firstname,
                                "lastname":lastname,
                                "email": email,
                                "profileImageUrl": profileImageUrl]

                                ref.child("users").child(result!.user.uid).setValue(values){
                                (err:Error?, ref:DatabaseReference) in
                                    if let error = error {
                                      print("Data could not be saved: \(error).")
                                    } else {
                                      print("Data saved successfully!")
                                    }
                                }
                                }
                            })
                            })
                        }
                    }
                }
                
                    //transition to home screen
                    self.transitionToHome()
                }
            
        }
        
    }
    
    @objc func imageTapped(gesture:UIGestureRecognizer)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage]
            as? UIImage {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            profPic.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}
