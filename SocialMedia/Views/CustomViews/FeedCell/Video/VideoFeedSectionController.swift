//
//  VideoFeedSectionController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 15/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

class VideoFeedSectionController: ListSectionController, UICollectionViewDelegateFlowLayout {
    
    var delegate: FeedItemDelegate?
    var viewPostDelegate: ViewPostDelegate?
    var viewFriendProfileDelegate: ViewFriendProfileDelegate?
    var socialTapDelegate: SocialLabelTapDelegate?

    private var object: FeedTypeVideo?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        //self.inset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
       
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        var height: CGFloat = 340
        
        if UIDevice.isiPad {
            height = 480
        }
        
        return CGSize(width: collectionContext!.containerSize.width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: FeedTypeVideoItem.self, for: self, at: index) as? FeedTypeVideoItem else {
            fatalError()
        }
        cell.videoPlayerContainer.heroID = String(index)
        cell.index = index
        cell.viewPostDelegate = viewPostDelegate
        cell.viewProfileDelegate = viewFriendProfileDelegate
        cell.socialTapDelegate = socialTapDelegate

        cell.videoThumbnailImageView.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        cell.userImageView.image = #imageLiteral(resourceName: "user")
        
        cell.sizeToFit()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? FeedTypeVideo
    }
}
