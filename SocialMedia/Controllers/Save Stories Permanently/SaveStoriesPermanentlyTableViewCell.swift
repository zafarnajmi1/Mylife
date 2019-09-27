//
//  SaveStoriesPermanentlyTableViewCell.swift
//  SocialMedia
//
//  Created by Macbook on 20/03/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class SaveStoriesPermanentlyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgStory: UIImageView!
    @IBOutlet weak var lblStoryOwnerName: UILabel!
    @IBOutlet weak var lblStoryTime: UILabel!
    @IBOutlet weak var btnStoryDelete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
