//
//  BookmarksCustomCell.swift
//  GitHunt
//
//  Created by Othmane on 6/28/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit

class BookmarksCustomCell: UITableViewCell {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var repoOwnerAvatar: UIImageView!
    @IBOutlet weak var repoOwnerLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
