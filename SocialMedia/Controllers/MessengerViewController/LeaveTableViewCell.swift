//
//  LeaveTableViewCell.swift
//  SocialMedia
//
//  Created by iOSDev on 7/18/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class LeaveTableViewCell: UITableViewCell {
    @IBOutlet weak var lbltext: UILabel!
    @IBOutlet weak var btnLeave: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
