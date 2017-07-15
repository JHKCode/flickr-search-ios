//
//  SearchHistoryManager.swift
//  FlickrSearch
//
//  Created by Jinhong Kim on 7/15/17.
//  Copyright © 2017 Jinhong Kim. All rights reserved.
//

import Foundation


class SearchHistoryManager {
    
    fileprivate static let flickrSearchKeywordsKey = "FlickrSearchKeywords"
    
    lazy fileprivate var keywords: Array<String> = self.loadKeywords()
    
    
    open func keywordCount() -> Int {
        return self.keywords.count
    }
    
    
    open func keyword(at indexPath: IndexPath) -> String? {
        return (0..<self.keywords.count).contains(indexPath.row) ? self.keywords[indexPath.row] : nil
    }
    
    
    open func addKeyword(_ keyword: String) {
        self.keywords.insert(keyword, at: 0)
        
        UserDefaults.standard.setValue(self.keywords, forKey: SearchHistoryManager.flickrSearchKeywordsKey)
    }
    
}


// MARK: Private Methods


extension SearchHistoryManager {
    
    fileprivate func loadKeywords() -> Array<String> {
        return (UserDefaults.standard.array(forKey: SearchHistoryManager.flickrSearchKeywordsKey) as? Array<String>) ?? []
    }
    
}
