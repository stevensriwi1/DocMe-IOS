//
//  HomeViewController.swift
//  
//
//  Created by Rachel Su Jia Xin on 6/1/20.
//

import UIKit
import Firebase
import FirebaseUI

class HomeViewController: UITableViewController {

    let cellId = "cellId"
    
    @IBOutlet weak var testing: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "addicon");
        let locationImage = UIImage(named: "location-icon");
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addNewMessage))
        navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: -50);
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: locationImage, style: .plain, target: self, action: #selector(googleMaps))
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0.0, left: -50, bottom: 0, right: 0);
        //user is not logged in
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        //observeMessages();
         
        
    }
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    func observeUsersMessages()
    {
        guard let uid = Auth.auth().currentUser?.uid else
        {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value, with:  { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    //self.messages.append(message)
                    
                    if let chatPartnerId = message.chatPartnerId() {
                        self.messagesDictionary[chatPartnerId ] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort { (message1, message2) -> Bool in
                            return (message1.timestamp as! Int) > (message2.timestamp as! Int)
                        }
                    }
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    
                }
                
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    var timer: Timer?
    @objc func handleReloadTable()
    {
        //call this on async dispatch main thread
        DispatchQueue.main.async {
            print("we have reloaded the table")
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        
        if let toId = message.toId {
            let ref = Database.database().reference().child("users").child(toId as! String)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]
                {
                    cell.textLabel?.text = (dictionary["firstname"] as! String) + " " + (dictionary["lastname"] as! String)
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String{
                        cell.profileimageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }
        }
        cell.message = message
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with:  { (snapshot) in
            guard let dictionary = snapshot.value as? [String:AnyObject]
                else {
                    return
            }
            let user = User()
            user.userId = chatPartnerId
            user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user: user)
        }, withCancel: nil)
        
    }
    @objc func addNewMessage() {
        let addMessageController = NewMessageController()
        addMessageController.homeController = self
        let navController = UINavigationViewController(rootViewController: addMessageController)
        present(navController, animated: true, completion: nil)
    }
    @objc func googleMaps() {
        let googleMapsController = GoogleMapsViewController()
        let navController = UINavigationViewController(rootViewController: googleMapsController)
        present(navController, animated: true, completion: nil)
    }
    func checkIfUserIsLoggedIn()
    {
        if Auth.auth().currentUser?.uid == nil{
            //perform(#selector(handleLogout), with: nil, afterDelay:0)
            handleLogout()
        }
        else{
            let uid = Auth.auth().currentUser?.uid;
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User()
                    user.setValuesForKeys(dictionary)
                    self.setupNavBarwithUser(user: user)
                }
              }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    func setupNavBarwithUser(user: User)
    {
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUsersMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = (user.firstname as! String)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        self.navigationItem.titleView = titleView
        
        
        //testing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
        //testing.isUserInteractionEnabled = true
    }
    @objc func showChatControllerForUser(user: User) {
        let chatlogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatlogController.user = user
        navigationController?.pushViewController(chatlogController, animated: true)
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
        
        
        let navigationViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationViewController) as? UINavigationViewController
        
        view.window?.rootViewController = navigationViewController
        view.window?.makeKeyAndVisible()
         
    }
    

    
    

}
