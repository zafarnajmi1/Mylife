//
//  LeftTableViewCell.swift
//  SocialMedia
//
//  Created by My Technology on 21/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class LeftTableViewCell: UITableViewCell {

    @IBOutlet var myImage: UIImageView!
    @IBOutlet var myTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
