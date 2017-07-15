//
//  FlickrFetchResult.swift
//  FlickrSearch
//
//  Created by Jinhong Kim on 7/15/17.
//  Copyright © 2017 Jinhong Kim. All rights reserved.
//

import Foundation


struct FlickrFetchResult {
    
    public let stat: String

    public let totalPages: Int
    
    public let totalPhotos: Int
    
    public let photos: Array<FlickrPhoto>
    
}
