//
//  User.swift
//  DocMe1
//
//  Created by Rachel Su Jia Xin on 1/2/20.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

class User: NSObject {

    //need to pass these to objc as we need it to be shown on the message list
    //THIS NEEDS TO BE EXACT WITH FIREBASE KEY NAME
    @objc var userId: String?
    @objc var firstname: AnyObject?
    @objc var lastname: AnyObject?
    @objc var email: AnyObject?
    @objc var profileImageUrl: AnyObject?
    
}
