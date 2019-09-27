//
//  FeedHeaderCell.swift
//  SocialMedia
//
//  Created by iOSDev on 10/25/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift


class FeedHeaderCell: UITableViewCell {

    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var viewLeftButtons: UIView!
    @IBOutlet weak var oltOptions: UIButton!
    @IBOutlet weak var oltInfo: UIButton!
    
    @IBOutlet var badgeLeadingCst: NSLayoutConstraint!
    @IBOutlet var badgeLbl: UILabel!
    @IBOutlet weak var imgCover: UIButton!
    @IBOutlet weak var viewRightButton: UIView!
    @IBOutlet weak var oltFriends: MIBadgeButton?
    @IBOutlet weak var oltMenu: UIButton!
    
    @IBOutlet weak var imgProfile: UIButton!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    //var Friends: MIBadgeButton?
    
     let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        badgeLbl.setCornerRadius(radius: 10)
        
        if lang == "ar" {
            badgeLeadingCst.constant = 8
        }
        else {
            badgeLeadingCst.constant = 36
        }
//        oltFriends = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        oltFriends!.setImage(#imageLiteral(resourceName: "friends"), for: .normal)
//        if(Count == ""){
//            Notificationbtn?.badgeString = nil
//        }
//        else if (Count == "0"){
//            Notificationbtn?.badgeString = nil
//
//        }
//        else
//        {
//            Notificationbtn?.badgeString = Count
//
//        }
        
//        Notificationbtn?.addTarget(self, action:#selector(AdminHome.notification_message), for: UIControlEvents.touchUpInside)
//        let notificationItem = UIBarButtonItem(customView: Notificationbtn!)
//        Notificationbtn!.badgeEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0)
        
        imgUserProfile.backgroundColor = UIColor.lightGray
       
        imageCover.backgroundColor = UIColor.lightGray
        
        // Initialization code        
        lblUserName.font = CommonMethods.getFontOfSize(size: 16)
        imgUserProfile.round()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
