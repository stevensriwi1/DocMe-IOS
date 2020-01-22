//
//  ViewController.swift
//  DocMe1
//
//  Created by Rachel Su Jia Xin on 27/12/19.
//  Copyright © 2019 Steven. All rights reserved.
//

import UIKit
import FirebaseUI
import GoogleSignIn

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func LoginButton(_ sender: UIButton) {
        
        //get default auth UI object
        let authUI = FUIAuth.defaultAuthUI();        guard authUI != nil else
        {
            //log the error
            return
        }
        /*
        let providers: [FUIAuthProvider] = [
          FUIEmailAuth(),
          FUIGoogleAuth(),
          FUIFacebookAuth(),
        ]
        self.authUI?.providers = providers
        */
        
        //set ourselves as the delegate
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        
        
        //get a reference to the  auth UI view controller
        let authViewController = authUI!.authViewController();
        
        //show it
        present(authViewController, animated: true, completion: nil);
        
    }

}

extension ViewController:FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        //check if there was an erroe
        
        if error != nil{
            //log error
            return;
        }
        //authDataResult?.user.uid;
        
        performSegue(withIdentifier: "goToHome", sender: self);
    }
}
