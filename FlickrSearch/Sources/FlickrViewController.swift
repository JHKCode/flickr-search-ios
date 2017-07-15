//
//  FlickrViewController.swift
//  FlickrSearch
//
//  Created by Jinhong Kim on 7/15/17.
//  Copyright © 2017 Jinhong Kim. All rights reserved.
//

import UIKit

class FlickrViewController: UIViewController {

    @IBOutlet weak var keywordTableView: UITableView!
    
    fileprivate var searchHistoryManager = SearchHistoryManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Flickr"
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


// MARK: UISearchBarDelegate


extension FlickrViewController: UISearchBarDelegate {
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        self.keywordTableView.isHidden = false
        self.keywordTableView.reloadData()
    }

    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.keywordTableView.isHidden = true
    }
    
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, keyword.isEmpty == false else {
            return
        }
        
        self.searchHistoryManager.addKeyword(keyword)
        
        searchBar.resignFirstResponder()
    }

    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}


// MARK: UITableViewDataSource


extension FlickrViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchHistoryManager.keywordCount()
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchKeywordCell") as? SearchKeywordCell else {
            return UITableViewCell(frame: .zero)
        }
        
        cell.keyword = self.searchHistoryManager.keyword(at: indexPath)
        
        return cell
    }

}


// MARK: UITableViewDelegate

extension FlickrViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let keyword = (tableView.cellForRow(at: indexPath) as? SearchKeywordCell)?.keyword {
            //self.searchFlickr(withKeyword: keyword)
        }
    }

}
