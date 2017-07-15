//
//  FlickrPhoto.swift
//  FlickrSearch
//
//  Created by Jinhong Kim on 7/15/17.
//  Copyright © 2017 Jinhong Kim. All rights reserved.
//

import Foundation


struct FlickrPhoto {
    
    public let id: String
    
    public let owner: String
    
    public let secret: String
    
    public let server: String
    
    public let farm: Int
    
    public let title: String
    
    public let isPublic: Bool
    
    public let isFriend: Bool
    
    public let isFamily: Bool
    
    public var url: URL? {
        return URL(string: "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg")
    }
}
