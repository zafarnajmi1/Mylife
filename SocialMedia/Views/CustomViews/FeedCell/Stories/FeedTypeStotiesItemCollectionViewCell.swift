//
//  FeedTypeStotiesItemCollectionViewCell.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 16/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

class FeedTypeStotiesItemCollectionViewCell: UICollectionViewCell, Xibable {
    @IBOutlet var imageViewUser: UIImageView! {
        didSet {
            imageViewUser.roundWithClearColor()
        }
    }
    
    
    @IBOutlet var buttonAddStory: UIButton! {
        didSet {
            buttonAddStory.isHidden = true
        }
    }
    @IBOutlet var labelUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
}
