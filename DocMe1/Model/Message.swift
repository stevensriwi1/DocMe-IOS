//
//  Message.swift
//  DocMe1
//
//  Created by Rachel Su Jia Xin on 5/2/20.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import FirebaseUI

class Message: NSObject
{
   @objc var fromId: AnyObject?
   @objc var text: AnyObject?
   @objc var timestamp: NSNumber?
   @objc var toId: AnyObject?
    
    
    func chatPartnerId() -> String?
    {
        //if the fromId is equal to the current id, then set the messages cell to the toId
        if fromId as? String == Auth.auth().currentUser?.uid {
            return toId as? String
        }
        else {
            return fromId as? String
        }
    }
}
