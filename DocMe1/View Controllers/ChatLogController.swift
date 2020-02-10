//
//  ChatLogController.swift
//  DocMe1
//
//  Created by Rachel Su Jia Xin on 3/2/20.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import FirebaseUI

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // to make an 8 px padding on top and 58 px padding on bottom
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        setupInputComponent()
    }
    
    var user: User?
    {
        didSet{
            navigationItem.title = user?.firstname as? String
            
            observeMessages()
        }
    }

    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message()
                //potentially crashes if the key does not match up
                message.setValuesForKeys(dictionary)
                // check whether the id is the same id as the current ones.
                if message.chatPartnerId() == self.user?.userId {
                    self.messages.append(message)
                    //as it is running behind the main thread, we need to call the following
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message ...."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text as? String
        
        setupcellColor(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: message.text as! String).width + 30
        
        return cell
    }
    private func setupcellColor (cell:ChatMessageCell, message:Message)
    {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl as! String);
        }
        
        if (message.fromId as! String) == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor.systemBlue
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }
        else {
            //run when the message is from sender to currentUser
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        //get estimated height
        if let text = messages[indexPath.item].text {
            //adding 20 as we would want to make it abit more space so it wont cut the some of the wording pixel
            height = estimatedFrameForText(text: text as! String).height + 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 16.0)!], context: nil)
    }
    func setupInputComponent()
    {
        
        //containerbottom
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //send button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false;
        
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor ).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //textfield
        containerView.addSubview(inputTextField)
        //move 8 pixels to right
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor ).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
       
        //seperator
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor.darkGray
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(seperatorLineView)
        
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor ).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc func handleSend()
    {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.userId!
        let fromId = Auth.auth().currentUser?.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        //reciever is the uid of any user that you chose to send to
        //sender is the uid of current user
        let value = ["text": inputTextField.text!, "toId" : toId, "fromId" : fromId!, "timestamp": timestamp] as [String : Any]
        //childRef.updateChildValues(value)
        childRef.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            self.inputTextField.text = nil
                //set database from the logged in recipient that sent the message
                let userMessageRef = Database.database().reference().child("user-messages").child(fromId!)
                let messageId = childRef.key
                userMessageRef.updateChildValues([messageId!:1])
                print(userMessageRef)
                //set data with the selected recipient
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
                recipientUserMessagesRef.updateChildValues([messageId!:1])
            
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        
        return true
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //will automatically update if we rotate the screen
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}
