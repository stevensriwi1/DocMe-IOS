//
//  SignUpViewController.swift
//  DocMe1
//
//  Created by Rachel Su Jia Xin on 6/1/20.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var profPic: UIImageView!
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        //create tap gesture recognition
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        //add it to the image view
        profPic.addGestureRecognizer(tapGesture)
        //make sure imageView can be interacted by the user
        profPic.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements()
    {
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }

    //check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otehrwise, it will returns the error message
    func validateFields() -> String?
    {
        //check that all fields are filled in
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all the fields"
        }
         //check if the password is valid or secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false
        {
            //password is not secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
    }
    
    
    func showError(_ message:String)
    {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    func transitionToHome()
    {
        //reference to Home View Cotroller
        let tabController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabController) as? TabViewController
        
        view.window?.rootViewController = tabController
        view.window?.makeKeyAndVisible()
    }
    
}
