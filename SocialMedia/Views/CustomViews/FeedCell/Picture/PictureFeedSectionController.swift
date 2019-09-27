//
//  SimpleFeedSectionController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 15/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit
import IGListKit
var counter = 0
class PictureFeedSectionController: ListSectionController, UICollectionViewDelegateFlowLayout {
    var entry: JournalEntry!
    var delegate: FeedItemDelegate?
    var viewPostDelegate: ViewPostDelegate?
    var viewFriendProfileDelegate: ViewFriendProfileDelegate?
    var socialTapDelegate: SocialLabelTapDelegate?
    var image_request = [String]()
    private var object: FeedTypePicture?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    override func sizeForItem(at index: Int) -> CGSize {
        var height: CGFloat = 401
        
        if UIDevice.isiPad {
            height = 480
        }
        
        return CGSize(width: collectionContext!.containerSize.width, height: height)
    }
//    override func numberOfItems() -> Int {
//        return 1
//    }
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: FeedTypePictureItem.self, for: self, at: index) as? FeedTypePictureItem else {
            fatalError()
        }
        
        print("Counter = ", counter)
        print("index = ",index)
        cell.backgroundColor = UIColor.red
        cell.layer.cornerRadius = 40
        cell.postImageView.heroID = String(index)
        cell.index = index
        cell.viewPostDelegate = viewPostDelegate
        cell.viewProfileDelegate = viewFriendProfileDelegate
        cell.socialTapDelegate = socialTapDelegate
        
        if (entry != nil)
        {
            cell.postImageView.sd_setImage(with: URL(string: entry.image), placeholderImage: UIImage(named: "placeholder.png"))
        }
        else
        {
             cell.postImageView.sd_setImage(with: URL(string: "https://www.edgehill.ac.uk/study/files/2017/03/Nightlife.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
        }
        
        
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        entry = object as? JournalEntry
    }
}
