//
//  SearchHistoryManager.swift
//  FlickrSearch
//
//  Created by Jinhong Kim on 7/15/17.
//  Copyright © 2017 Jinhong Kim. All rights reserved.
//

import Foundation


/// search hisoty manager
/// it saves search history in user defaults
class SearchHistoryManager {
    
    fileprivate static let flickrSearchKeywordsKey = "FlickrSearchKeywords"
    
    lazy fileprivate var keywords: Array<String> = self.loadKeywords()
    
    
    // total count
    open func keywordCount() -> Int {
        return self.keywords.count
    }
    
    
    // keyword at index path
    open func keyword(at indexPath: IndexPath) -> String? {
        return (0..<self.keywords.count).contains(indexPath.row) ? self.keywords[indexPath.row] : nil
    }
    
    
    // add or update search keyword
    open func addKeyword(_ keyword: String) {
        if let index = self.keywords.index(of: keyword) {
            self.keywords.remove(at: index)
        }
        
        self.keywords.insert(keyword, at: 0)
        
        UserDefaults.standard.setValue(self.keywords, forKey: SearchHistoryManager.flickrSearchKeywordsKey)
    }
    
}


// MARK: Private Methods


extension SearchHistoryManager {
    
    // load keywords from user defaults
    fileprivate func loadKeywords() -> Array<String> {
        return (UserDefaults.standard.array(forKey: SearchHistoryManager.flickrSearchKeywordsKey) as? Array<String>) ?? []
    }
    
}
