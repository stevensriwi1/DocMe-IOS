//
//  extensions.swift
//  DocMe1
//
//  Created by Rachel Su Jia Xin on 3/2/20.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String)
    {
        //check cach for image first
        
        if let cachedImage = imageCache.object(forKey: urlString as NSObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString )
        URLSession.shared.dataTask(with: url!, completionHandler:  { (data, response, error) in
            
            //downloadhit an error so lets return out
            if error != nil {
                print(error)
                return
            }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!)
                    {
                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                        
                        self.image = downloadedImage
                    }
                }
            
        }).resume()
    }
}
