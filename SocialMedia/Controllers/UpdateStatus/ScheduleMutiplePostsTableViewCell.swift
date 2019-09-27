//
//  ScheduleMutiplePostsTableViewCell.swift
//  SocialMedia
//
//  Created by Imran Jameel on 1/16/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class ScheduleMutiplePostsTableViewCell: UITableViewCell {

    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var selectedDateLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
