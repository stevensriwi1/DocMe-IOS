//
//  SettingsViewController.swift
//  DocMe1
//
//  Created by Rachel Su Jia Xin on 13/1/20.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var logOutBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logOutBtnTapped(_ sender: Any) {
        handleLogout()
        
    }
    

    func handleLogout()
    {
        //will try to do the following, because sometimes it gives an error
        do {
            try Auth.auth().signOut()
        }
        catch let logoutError
        {
            print(logoutError)
        }
        //reference to View Cotroller
        let navigationViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationViewController) as? UINavigationViewController
        
        view.window?.rootViewController = navigationViewController
        view.window?.makeKeyAndVisible()
    }
}
