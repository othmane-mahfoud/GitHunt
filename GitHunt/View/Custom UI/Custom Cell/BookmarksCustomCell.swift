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
    
    //Closures
    var didClickRemoveBtn : ((BookmarksCustomCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        deleteButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {self.deleteButton.transform = CGAffineTransform.identity},
                       completion: { Void in()  }
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.didClickRemoveBtn?(self)
        }
    }
    
}
