//
//  FlickrViewController.swift
//  FlickrSearch
//
//  Created by Jinhong Kim on 7/15/17.
//  Copyright © 2017 Jinhong Kim. All rights reserved.
//

import UIKit

class FlickrViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var keywordTableView: UITableView!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    fileprivate var searchHistoryManager = SearchHistoryManager()
    
    fileprivate var fetchManager = FlickrFetchManager()
    
    
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
        
        self.search(keyword)
        
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
        if let keyword = (tableView.cellForRow(at: indexPath) as? SearchKeywordCell)?.keyword, keyword.isEmpty == false {
            self.search(keyword)
        }
    }

}


// MARK: UICollectionViewDataSource


extension FlickrViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell(frame: .zero)
    }

}


// MARK: Private Method


extension FlickrViewController {
    
    func search(_ keyword: String) {
        self.searchBar.resignFirstResponder()
        self.keywordTableView.isHidden = true
        self.searchHistoryManager.addKeyword(keyword)
        _ = self.fetchManager.fetch(keyword: keyword)
    }
    
}
