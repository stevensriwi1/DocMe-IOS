//
//  NewMessageController.swift
//  DocMe1
//
//  Created by Rachel Su Jia Xin on 1/2/20.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
        
    }
    func fetchUser()
    {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                let user=User()
                user.userId = snapshot.key
                //if you use this setter, your app will crash if your class props don't exactly match up with the firebase dictionary keys
                
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                print(user.firstname!, user.lastname!, user.email!)
                DispatchQueue.global(qos: .userInitiated).async {
                    // Bounce back to the main thread to update the UI
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }, withCancel: nil)
    }
    @objc func handleCancel()
    {
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let use a hack for now
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = (user.firstname! as! String) + " " + (user.lastname! as! String)
        cell.detailTextLabel?.text = (user.email! as! String)
        //cell.imageView?.image = UIImage(named: "user")
        //print(user.profileImageUrl as! String)
        //making the profile image url to the url of the database user's image
        if let profileImageUrl = user.profileImageUrl{
            
            
            cell.profileimageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl as! String)
            
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    var homeController: HomeViewController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            //user equeals to which ever you have selected
            let user = self.users[indexPath.row]
            self.homeController?.showChatControllerForUser(user: user)
        }
    }
}
