//
//  PhotoImageView.swift
//  FlickrSearch
//
//  Created by Jinhong Kim on 7/15/17.
//  Copyright © 2017 Jinhong Kim. All rights reserved.
//

import UIKit

class PhotoImageView: UIImageView {

    var url: URL?
    
    var task: URLSessionDownloadTask?
    
    
    // load image from url
    open func loadImage(withURL url: URL) {
        if let task = self.task {
            task.cancel()
        }
        
        // save the lastes url request
        self.url = url
        
        self.task = URLSession.shared.downloadTask(with: url, completionHandler: { (fileUrl: URL?, response: URLResponse?, error: Error?) in
            // skip image because new url is requested
            if self.url != url {
                return
            }
            
            // load image from url
            guard let image = fileUrl.flatMap({ try? Data(contentsOf: $0) }).flatMap({ UIImage(data: $0) }) else {
                return
            }
            
            // update image
            DispatchQueue.main.async {
                self.image = image
            }
        })
        
        self.task?.resume()
    }

    
    // cancel request
    open func canel() {
        self.task?.cancel()
        self.url = nil
    }
}
