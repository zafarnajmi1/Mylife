//
//  CellGroupChatParticipant.swift
//  SocialMedia
//
//  Created by Mughees Musaddiq on 24/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SDWebImage

class CellGroupChatParticipant: UITableViewCell {

    @IBOutlet weak var imgUserImage: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnOpenUserProfile: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgUserImage.layer.cornerRadius = 18.0
        imgUserImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
