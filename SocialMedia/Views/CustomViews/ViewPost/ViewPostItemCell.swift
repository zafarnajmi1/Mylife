//
//  ViewPost.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 17/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit

class ViewPostItemCell: UICollectionViewCell, Xibable {
    
    var viewProfileDelegate: ViewFriendProfileDelegate?
    
    var socialDelagate: SocialButtonDelegate?
    var socialTapDelegate: SocialLabelTapDelegate?

    @IBOutlet var postContainerView: UIView!
    
    @IBOutlet var imageViewUser: UIImageView!
    
    @IBOutlet var labelUserName: UILabel!
    
    @IBOutlet var labelPostTime: UILabel!
    
    @IBOutlet var buttonsContainer: UIView! {
        didSet {
            buttonsContainer.addBottomBorder(color: .white)
            buttonsContainer.addTopBorder(color: .white)
        }
    }
    
    var profileId = 0
    
    @IBAction func onFriendProfileTapped(_ sender: UITapGestureRecognizer) {
        viewProfileDelegate?.didTapOnFriendProfile(profileId: profileId)
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
       
    func addImageViewWith(image: UIImage) {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.motionIdentifier = "photo_\(self.tag)"

        postContainerView.clipsToBounds = true
        postContainerView.layout(imageView).edges()
        postContainerView.backgroundColor = .clear
        
        imageView.image = image
    }
    
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
