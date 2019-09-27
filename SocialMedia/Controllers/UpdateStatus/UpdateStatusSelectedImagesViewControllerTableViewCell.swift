//
//  UpdateStatusSelectedImagesViewControllerTableViewCell.swift
//  SocialMedia
//
//  Created by Imran Jameel on 1/19/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class UpdateStatusSelectedImagesViewControllerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var showImageForZoomButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
