//
//  Data+Extensions.swift
//  FlickrSearch
//
//  Created by Jinhong Kim on 7/15/17.
//  Copyright © 2017 Jinhong Kim. All rights reserved.
//

import Foundation


extension Data {
    
    // convert data to Dictionary<String, Any> JSON Object
    func jsonDictonary() -> Dictionary<String, Any>? {
        return (try? JSONSerialization.jsonObject(with: self)).flatMap({ $0 as? Dictionary<String, Any> })
    }
    
}
