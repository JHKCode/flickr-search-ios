//
//  PhotoCell.swift
//  FlickrSearch
//
//  Created by Jinhong Kim on 7/15/17.
//  Copyright © 2017 Jinhong Kim. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: PhotoImageView!
    
    
    override func prepareForReuse() {
        self.imageView.canel()
        self.imageView.image = nil
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.frame = self.bounds
    }
    
    
    open func loadImage(withURL url: URL) {
        self.imageView.loadImage(withURL: url)
    }
    
}
