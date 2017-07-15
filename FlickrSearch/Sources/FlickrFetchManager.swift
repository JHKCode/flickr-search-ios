//
//  FlickrFetchManager.swift
//  FlickrSearch
//
//  Created by Jinhong Kim on 7/15/17.
//  Copyright © 2017 Jinhong Kim. All rights reserved.
//

import Foundation

/// protocol to notify a fetch result
protocol FlickrFetchManagerDelegate: class {
    
    func fetchManagerDidFetchCompleted(_: FlickrFetchManager)
    
    func fetchManager(_: FlickrFetchManager, didFailWithError: Error?)
    
}


class FlickrFetchManager {
    
    static fileprivate let searchURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text="
    
    // delegate
    open weak var delegate: FlickrFetchManagerDelegate?
    
    
    fileprivate var page: Int = 1
    
    fileprivate var numberOfPhotosPerPage: Int = 100
    
    fileprivate var task: URLSessionDataTask?
    
    fileprivate var keyword: String = ""
    
    fileprivate var fetchResult: FlickrFetchResult?
    
    
    init(withNumberOfPhotosPerPage numberOfPhotos: Int = 100) {
        self.numberOfPhotosPerPage = numberOfPhotos
    }
    
    
    open func fetch(keyword: String) -> Bool {
        if let curTask = self.task {
            curTask.cancel()
        }
        
        guard let url = URL(string: FlickrFetchManager.searchURLString + keyword) else {
            return false
        }
        
        // save last keyword
        self.keyword = keyword
        
        self.task = URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if let err = error {
                print("fetch error: \(err)")
                self.delegate?.fetchManager(self, didFailWithError: error)
                return
            }
            
            // check if the response is the latest search request
            if self.keyword != keyword {
                return
            }
            
            // make fetch result model
            self.fetchResult = self.processFetchResult(data)
            
            // notify
            self.delegate?.fetchManagerDidFetchCompleted(self)
        })
        
        
        if self.task == nil {
            return false
        }
        
        self.task?.resume()
        
        return true
    }
    
    
    open func fetchNext() {
        
    }
    
}


extension FlickrFetchManager {

    fileprivate func processFetchResult(_ data: Data?) -> FlickrFetchResult? {
        guard let json = data?.jsonDictonary() else {
            return nil
        }
        
        // stat
        guard let stat = json["stat"] as? String else {
            return nil
        }
        
        // photos
        guard let photos = json["photos"] as? Dictionary<String, Any> else {
            return nil
        }
        
        // total pages
        guard let totalPages = photos["pages"] as? Int else {
            return nil
        }
        
        // total photos
        guard let totalPhotos = (photos["total"] as? String).flatMap({ Int($0) })  else {
            return nil
        }
        
        // photo
        guard let photo = photos["photo"] as? Array<Dictionary<String, Any>> else {
            return nil
        }

        return FlickrFetchResult(stat: stat, totalPages: totalPages, totalPhotos: totalPhotos, photos: self.processPhoto(photo))
    }
    
    
    fileprivate func processPhoto(_ photos: Array<Dictionary<String, Any>>) -> Array<FlickrPhoto> {
        var flickrPhotos = Array<FlickrPhoto>()
        
        for photo in photos {
            // id
            guard let id = photo["id"] as? String else { continue }
            
            // owner
            guard let owner = photo["owner"] as? String else { continue }
            
            // secret
            guard let secret = photo["secret"] as? String else { continue }
            
            // server
            guard let server = photo["server"] as? String else { continue }
            
            // farm
            guard let farm = photo["farm"] as? Int else { continue }
            
            // title
            guard let title = photo["title"] as? String else { continue }
            
            // public
            guard let isPublic = photo["ispublic"] as? Bool else { continue }
            
            // friend
            guard let isFriend = photo["isfriend"] as? Bool else { continue }

            // family
            guard let isFamily = photo["isfamily"] as? Bool else { continue }
            
            let flickrPhoto = FlickrPhoto(id: id,
                                          owner: owner,
                                          secret: secret,
                                          server: server,
                                          farm: farm,
                                          title: title,
                                          isPublic: isPublic,
                                          isFriend: isFriend,
                                          isFamily: isFamily)
            flickrPhotos.append(flickrPhoto)
        }
        
        return flickrPhotos
    }
    
}
