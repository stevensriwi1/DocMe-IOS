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
import AVKit

class ViewController: UIViewController {

    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //set up video in background
        setUpVideo()
    }
    func setUpElements()
    {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        
    }
    func setUpVideo()
    {
        //get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "video", ofType: "mp4")
        
        guard bundlePath != nil else
        {
            return
            
        }
        //create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        //create the video player item
        let item = AVPlayerItem(url:url)
        
        //create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        
        //create the layer
        videoPlayerLayer=AVPlayerLayer(player: videoPlayer!)
        
        
        //adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*0.7, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // Add it to the view and play it
        videoPlayer?.playImmediately(atRate: 0.3)
    }
    func transitionToHome()
    {
        //reference to Home View Cotroller
        let tabViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabController) as? TabViewController
        
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
    }
    
    
}
