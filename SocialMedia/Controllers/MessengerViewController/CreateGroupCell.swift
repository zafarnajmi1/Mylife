//
//  CreateGroupCell.swift
//  SocialMedia
//
//  Created by Mughees Musaddiq on 18/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class CreateGroupCell: UITableViewCell {

    @IBOutlet weak var imgViewProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgViewProfilePic.layer.cornerRadius = 35
        imgViewProfilePic.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
