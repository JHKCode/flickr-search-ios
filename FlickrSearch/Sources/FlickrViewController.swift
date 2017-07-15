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
    
    @IBOutlet weak var keyboardTableViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    fileprivate var searchHistoryManager = SearchHistoryManager()
    
    fileprivate var fetchManager = FlickrFetchManager()
    
    open var column: Int = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Flickr"
        self.fetchManager.delegate = self
        
        self.setupNotification()
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.layoutCollectionView()
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
        
        // start search
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
        return self.fetchManager.photoCount()
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell(frame: .zero)
        }
        
        // load photo image
        if let photo = self.fetchManager.photo(at: indexPath), let url = photo.url {
            cell.loadImage(withURL: url)
        }
        
        // fetch next page if collection view request the last item
        // fetch manager don't fetch for the same page, so duplicate fetch call is safe
        if indexPath.row + 1 == self.fetchManager.photoCount() {
            _ = self.fetchManager.fetch(keyword: self.fetchManager.keyword)
        }
        
        return cell
    }

}


// MARK: FlickrFetchManagerDelegate


extension FlickrViewController: FlickrFetchManagerDelegate {
    
    func fetchManagerDidFetchCompleted(_: FlickrFetchManager) {
        DispatchQueue.main.async {
            self.photoCollectionView.setContentOffset(.zero, animated: false)
            self.activityIndicator.stopAnimating()
            self.photoCollectionView.reloadData()
        }
    }
    
    
    func fetchManager(_: FlickrFetchManager, didFailWithError error: Error?) {
        print("fetch error: \(String(describing: error))")
        self.activityIndicator.stopAnimating()
    }
    
}


// MARK: Private Method


extension FlickrViewController {
    
    func setupNotification() {
        // to adjust keyword table view size
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil, queue: nil) { [weak self] (notification) in
            guard let frame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            
            self?.keyboardTableViewBottomConstraint.constant = UIScreen.main.bounds.height - frame.origin.y
        }
    }
    
    
    func layoutCollectionView() {
        // reset collection view cell size
        if let flowLayout = self.photoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let viewSize = self.view.bounds.size
            let width = (viewSize.width / CGFloat(self.column)) - (flowLayout.minimumInteritemSpacing * CGFloat(self.column - 1))
            
            flowLayout.itemSize = CGSize(width: width, height: width)
        }
    }
    
    
    func search(_ keyword: String) {
        self.searchBar.text = keyword
        self.searchBar.resignFirstResponder()
        self.keywordTableView.isHidden = true
        self.activityIndicator.startAnimating()
        
        self.searchHistoryManager.addKeyword(keyword)
        _ = self.fetchManager.fetch(keyword: keyword)
    }
    
}
