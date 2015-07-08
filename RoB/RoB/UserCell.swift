//
//  UserCell.swift
//  
//
//  Created by Alexander Mogavero on 7/07/2015.
//
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
        avatarImageView.layer.masksToBounds = true
        
        
    }
}
