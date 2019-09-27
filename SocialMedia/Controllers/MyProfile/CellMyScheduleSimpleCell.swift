//
//  CellMyScheduleSimpleCell.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 24/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class CellMyScheduleSimpleCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet var imgFeed: UIImageView!
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    @IBOutlet weak var oltRemovePost: UIButton!
    @IBOutlet weak var oltEditPost: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblUserName.font = CommonMethods.getFontOfSize(size: 14)
        lblDescription.font = CommonMethods.getFontOfSize(size: 12)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
