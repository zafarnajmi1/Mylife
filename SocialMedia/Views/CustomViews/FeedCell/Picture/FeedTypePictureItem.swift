//
//  FeedCellType1.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 15/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

class FeedTypePictureItem: UICollectionViewCell, Xibable {
    
    var viewPostDelegate: ViewPostDelegate?
    var viewProfileDelegate: ViewFriendProfileDelegate?
    var socialDelagate: SocialButtonDelegate?
    var socialTapDelegate: SocialLabelTapDelegate?
    
    var index = 0
    
    @IBOutlet var postImageView: UIImageView!
    
    @IBOutlet var userImageView: UIImageView!
    
    var profileId = 0
    
    @IBAction func onViewPostTapped(_ sender: UITapGestureRecognizer) {
        viewPostDelegate?.didTapOnPost(at: index)
    }
    
    @IBAction func onFriendProfileTapped(_ sender: UITapGestureRecognizer) {
        viewProfileDelegate?.didTapOnFriendProfile(profileId: profileId)
        UserDefaults.standard.set("-1", forKey: "userlocalId")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func onButtonLikeClicked(_ sender: UIButton) {
        socialDelagate?.didTapOnLikeButton()
    }
    
    @IBAction func onButtonCommentClicked(_ sender: UIButton) {
        socialDelagate?.didTapOnCommentButton()
    }
    
    @IBAction func oButtonShareClicked(_ sender: UIButton) {
        socialDelagate?.didTapOnShareButton()
    }
    
    @IBAction func onLikeTapped(_ sender: UITapGestureRecognizer) {
        socialTapDelegate?.didTapOnLikeLabel()
    }
    
    
    @IBAction func onCommentTapped(_ sender: UITapGestureRecognizer) {
        socialTapDelegate?.didTapOnCommenLabel()
    }
    
    @IBAction func onShareTapped(_ sender: UITapGestureRecognizer) {
        socialTapDelegate?.didTapOnShareLabel()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupXib()
        postImageView.layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
        postImageView.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
        postImageView.layer.cornerRadius = 10
//        postImageView.borderWidth = 2
        postImageView.clipsToBounds = true
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.topLeft, .topRight], radius: postImageView.layer.cornerRadius)
    }
}
