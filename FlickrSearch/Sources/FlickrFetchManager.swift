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


/// fetch photo information by search from keyword
class FlickrFetchManager {
    
    static fileprivate let searchURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text="
    
    // delegate
    open weak var delegate: FlickrFetchManagerDelegate?
    
    // keyword
    open var keyword: String = ""

    
    fileprivate var page: Int = 0
    
    fileprivate var fetchingPage: Int = 0

    fileprivate var numberOfPage: Int = 0
    
    fileprivate var photos: Array<FlickrPhoto> = []
    
    fileprivate var numberOfPhotosPerPage: Int = 100
    
    fileprivate var task: URLSessionDataTask?
    
    
    init(withNumberOfPhotosPerPage numberOfPhotos: Int = 100) {
        self.numberOfPhotosPerPage = numberOfPhotos
    }
    
    
    open func fetch(keyword: String) -> Bool {
        if self.keyword != keyword {
            self.reset()
            self.keyword = keyword
        }
        
        // no more page remains
        if self.numberOfPage > 0 && self.page == self.numberOfPage {
            return false
        }
        
        // check if fetching is on going
        if self.fetchingPage > self.page {
            return false
        }

        // generate url
        guard let url = URL(string: FlickrFetchManager.searchURLString + keyword + "&page=\(self.page + 1)&per_page=\(self.numberOfPhotosPerPage)") else {
            return false
        }
        
        // save current fetching page
        self.fetchingPage = self.page + 1
        
        // fetch photos
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
            
            // process fetched data
            if self.processFetchResult(data) == true {
                self.delegate?.fetchManagerDidFetchCompleted(self)
            } else {
                self.delegate?.fetchManager(self, didFailWithError: nil)
            }
        })
        
        
        if self.task == nil {
            return false
        }
        
        self.task?.resume()
        
        return true
    }

    
    // total photo count
    open func photoCount() -> Int {
        return self.photos.count
    }
    
    
    // photo information at index path
    open func photo(at indexPath: IndexPath) -> FlickrPhoto? {
        return self.photos[indexPath.row]
    }
    
}


// MARK: Process Fetch Result


extension FlickrFetchManager {

    // process fetch result
    fileprivate func processFetchResult(_ data: Data?) -> Bool {
        guard let json = data?.jsonDictonary() else {
            return false
        }
        
        // stat
        guard let stat = json["stat"] as? String, stat == "ok" else {
            return false
        }
        
        // photos
        guard let photos = json["photos"] as? Dictionary<String, Any> else {
            return false
        }
        
        // total pages
        guard let totalPages = photos["pages"] as? Int else {
            return false
        }
        
        // current page
        guard let page = photos["page"] as? Int else {
            return false
        }
        
        // total photos
        /*
        guard let totalPhotos = (photos["total"] as? String).flatMap({ Int($0) })  else {
            return nil
        }
         */
        
        // photo
        guard let photo = photos["photo"] as? Array<Dictionary<String, Any>> else {
            return false
        }

        self.page = page
        self.numberOfPage = totalPages
        self.photos.append(contentsOf: self.processPhoto(photo))
        
        return true
    }
    
    
    // process fetched photos info
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


// MARK: Reset


extension FlickrFetchManager {
    
    func reset() {
        self.task?.cancel()
        
        self.keyword = ""
        self.page = 0
        self.fetchingPage = 0
        self.numberOfPage = 0
        self.photos.removeAll()
    }
    
}
