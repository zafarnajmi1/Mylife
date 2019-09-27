//
//  UpdateStatusSectionHeader.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 18/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

class UpdateStatusSectionController: ListSectionController, UICollectionViewDelegateFlowLayout {
    private var object: UpdateStatusObject?
    
    var delegate: UpdateStatusDelegate?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        var height: CGFloat = 60
        
        if UIDevice.isiPad {
            height = 80
        }
        
        return CGSize(width: collectionContext!.containerSize.width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: UpdateStatus.self, for: self, at: index) as? UpdateStatus else {
            fatalError()
        }
        
        cell.delegate = delegate
        
        cell.sizeToFit()
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? UpdateStatusObject
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.onUpdateStatusClicked()
    }
    
}
