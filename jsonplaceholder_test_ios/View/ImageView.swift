//
//  ImageView.swift
//  jsonplaceholder_test_ios
//
//  Created by Andrey Leganov on 9/5/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageView: UIImageView {
        
    var imageUrlString: String?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    func setImage(urlString: String) {
        image = nil
        imageUrlString = urlString
        setActivityIndicator()
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            image = imageFromCache
            removeActivityIndicator()
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                    self.removeActivityIndicator()
                }
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
        }
        dataTask.resume()
    }
    
    private func setActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    private func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
    }
}
