//
//  SearchKeywordCell.swift
//  FlickrSearch
//
//  Created by Jinhong Kim on 7/15/17.
//  Copyright © 2017 Jinhong Kim. All rights reserved.
//

import UIKit

class SearchKeywordCell: UITableViewCell {

    @IBOutlet weak var keywordLabel: UILabel!
    
    var keyword: String? {
        get {
            return self.keywordLabel?.text
        }
        
        set {
            self.keywordLabel?.text = newValue
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
