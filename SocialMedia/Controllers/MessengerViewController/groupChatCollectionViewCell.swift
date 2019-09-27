//
//  groupChatCollectionViewCell.swift
//  SocialMedia
//
//  Created by My Technology on 09/10/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class groupChatCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var participantImage: UIImageView!{
    didSet{
    participantImage.roundWithClearColor()
    }
    }
    @IBOutlet var participantName: UILabel!
    
    @IBOutlet var onlineImage: UIImageView!
}
