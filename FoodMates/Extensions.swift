//
//  Extensions.swift
//  FoodMates
//
//  Created by Priyanka Gopakumar on 9/6/17.
//  Copyright © 2017 Priyanka Gopakumar. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String)
    {
        // blank out image initially
        self.image = #imageLiteral(resourceName: "smallLogoFoodmates")
        
        // check cache for image first 
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // Else fire a new download
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            
            // download had an error
            if error != nil {
                print (error)
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
                
            }
            
        }).resume()
    }
}
