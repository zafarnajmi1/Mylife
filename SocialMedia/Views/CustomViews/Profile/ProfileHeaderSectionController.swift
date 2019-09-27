//
//  ProfileHeaderSectionController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 17/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

class ProfileHeaderSectionController: ListSectionController, UICollectionViewDelegateFlowLayout {
    
    var delegate: ProfileHeaderDelegate?
    
    private var object: Profile?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        var height: CGFloat = 290
        
        if UIDevice.isiPad {
            height = 490
        }
        
        return CGSize(width: collectionContext!.containerSize.width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: ProfileHeaderView.self, for: self, at: index) as? ProfileHeaderView else {
            fatalError()
        }
        
        cell.delegate = delegate
        
        if let object = object {
            if object is SelfProfile {
                
            } else if object is OtherProfile {
                
            }
        }
        
        cell.imageViewBanner.image = #imageLiteral(resourceName: "photo_1")
        cell.imageViewProfile.image = #imageLiteral(resourceName: "face_Android")
        
        cell.sizeToFit()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? Profile
    }
    
}
