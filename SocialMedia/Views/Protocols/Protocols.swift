//
//  ViewFriendProtocol.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 31/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import IGListKit

typealias PostObject = ListDiffable

protocol ViewPostDelegate {
    func didTapOnPost(at index: Int)
}

protocol ViewFriendProfileDelegate {
    func didTapOnFriendProfile(profileId: Int)
}

protocol ViewMutualFriendsDelegate {
    func didTapOnMutualFriends(profileId: Int)
}

protocol SocialButtonDelegate {
    func didTapOnLikeButton()
    func didTapOnCommentButton()
    func didTapOnShareButton()
}

protocol SocialLabelTapDelegate {
    func didTapOnLikeLabel()
    func didTapOnCommenLabel()
    func didTapOnShareLabel()
}
