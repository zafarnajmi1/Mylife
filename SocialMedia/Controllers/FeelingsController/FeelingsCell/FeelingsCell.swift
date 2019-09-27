//
//  FeelingsCell.swift
//  SocialMedia
//
//  Created by iOSDev on 10/26/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit

class FeelingsCell: UITableViewCell {

    @IBOutlet weak var imgFeeling: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.font = CommonMethods.getFontOfSize(size: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
