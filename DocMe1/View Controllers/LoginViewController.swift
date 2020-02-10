//
//  LoginViewController.swift
//  DocMe1
//
//  Created by Rachel Su Jia Xin on 6/1/20.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser?.uid != nil{
            //perform(#selector(handleLogout), with: nil, afterDelay:0)
            transitionToHome()
        }
        
        setUpElements()
    }
    func setUpElements()
    {
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }


    @IBAction func loginTapped(_ sender: Any) {
        
        //validate textfields
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
               {
                errorLabel.text = "Please key in the textfields"
                errorLabel.alpha = 1
               }
        //cleaned version of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //sign in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                //could not sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                self.transitionToHome()
            }
        }
    }
    func transitionToHome()
    {
        //reference to Home View Cotroller
        let tabViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabController) as? TabViewController
        
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
    }
}
