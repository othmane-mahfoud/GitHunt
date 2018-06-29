//
//  CollectionCustomCell.swift
//  GitHunt
//
//  Created by Othmane on 6/29/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit

class CollectionCustomCell: UITableViewCell {

    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var collectionCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
