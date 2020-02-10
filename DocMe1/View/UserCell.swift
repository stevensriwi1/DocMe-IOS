//
//  UserCell.swift
//  DocMe1
//
//  Created by Rachel Su Jia Xin on 6/2/20.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit
import FirebaseUI

class UserCell: UITableViewCell{
    
    var message: Message? {
        didSet{
            setupProfileImageAndName()
            
            detailTextLabel?.text = message?.text as? String
            
            if let seconds = message?.timestamp?.doubleValue{
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
            
            
        }
    }
    private func setupProfileImageAndName ()
    {
        
        
        
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id as! String)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]
                {
                    self.textLabel?.text = (dictionary["firstname"] as! String) + " " + (dictionary["lastname"] as! String)
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String
                    {
                        self.profileimageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let textLabelrect = CGRect(x: 56, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        let detailTextLabelrect = CGRect(x: 56, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        textLabel?.frame = textLabelrect
        detailTextLabel!.frame = detailTextLabelrect
    }
    
    let profileimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        //label.text = "HH>MM>SS"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileimageView)
        addSubview(timeLabel)
        
        profileimageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileimageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileimageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileimageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
