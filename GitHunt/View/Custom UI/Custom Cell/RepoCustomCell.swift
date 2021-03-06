//
//  RepoCustomCell.swift
//  GitStars
//
//  Created by Othmane on 5/25/18.
//  Copyright © 2018 Othmane. All rights reserved.
//

import UIKit

class RepoCustomCell: UITableViewCell {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var repoOwnerNameLabel: UILabel!
    @IBOutlet weak var repoStarsLabel: UILabel!
    @IBOutlet weak var repoOwnerAvatarImageView: UIImageView!
    @IBOutlet weak var bookMarkButton: UIButton!
    @IBOutlet weak var addToCollectionButton: UIButton!
    
    var didClickPlusBtn : ((RepoCustomCell) -> Void)?
    var didClickBookmark : ((RepoCustomCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func bookMarkPressed(_ sender: Any) {
        bookMarkButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {self.bookMarkButton.transform = CGAffineTransform.identity},
                       completion: { Void in()  }
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.didClickBookmark?(self)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addToCollectionButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {self.addToCollectionButton.transform = CGAffineTransform.identity},
                       completion: { Void in()  }
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.didClickPlusBtn?(self)
        }
    }
    
}
