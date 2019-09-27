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

class StoriesFeedSectionController: ListSectionController {
    private var object: FeedTypeSimple?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 120)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: FeedTypeStoriesItem.self, for: self, at: index) as? FeedTypeStoriesItem else {
            fatalError()
        }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? FeedTypeSimple
    }
    
}
