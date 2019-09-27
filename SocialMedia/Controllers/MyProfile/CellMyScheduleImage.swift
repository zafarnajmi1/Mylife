//
//  CellMyScheduleImage.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 24/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class CellMyScheduleImage: UITableViewCell {
let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewMultipleFeedImages: UIView!
    @IBOutlet weak var imgFeedImage1: UIImageView!
    @IBOutlet weak var imgFeedImage2: UIImageView!
    @IBOutlet weak var imgFeedImage3: UIImageView!
    
    @IBOutlet weak var btnMoreFeedImages: UIButton!
    @IBOutlet weak var btnMoreFeedImages2: UIButton!
    
    @IBOutlet var imgFeed: UIImageView!
    @IBOutlet weak var imgPlay: UIImageView!
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet weak var txtDescriptionOfPost: UITextView!
    
    @IBOutlet weak var oltRemovePost: UIButton!
    @IBOutlet weak var oltEditPost: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(lang == "en")
        {
            lblUserName.textAlignment = .left
          //lblUserName.font = CommonMethods.getFontOfSize(size: 14)
        }else
        {
           lblUserName.textAlignment = .right
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
