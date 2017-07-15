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
    
    
    open func loadImage(withURL url: URL) {
        if let task = self.task {
            task.cancel()
        }
        
        // save the lastes url request
        self.url = url
        
        self.task = URLSession.shared.downloadTask(with: url, completionHandler: { (fileUrl: URL?, response: URLResponse?, error: Error?) in
            if self.url != url {
                return
            }
            
            guard let image = fileUrl.flatMap({ try? Data(contentsOf: $0) }).flatMap({ UIImage(data: $0) }) else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        })
        
        self.task?.resume()
    }

    
    open func canel() {
        self.task?.cancel()
        self.url = nil
    }
}
