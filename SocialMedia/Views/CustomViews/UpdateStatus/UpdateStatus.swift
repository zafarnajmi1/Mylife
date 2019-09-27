//
//  UpdateStatus.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 18/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import IGListKit

protocol UpdateStatusDelegate {
    func onUpdateStatusClicked()
}

extension UpdateStatusObject: Equatable {
    static public func ==(rhs: UpdateStatusObject, lhs: UpdateStatusObject) -> Bool {
        return lhs.id == rhs.id
    }
}

class UpdateStatusObject: ListDiffable {
    var id = 1
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSNumber(value: id)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? UpdateStatusObject else {
            return false
        }
        
        if id != object.id {
            return false
        }
        
        return self == object
    }
}

class UpdateStatus: UICollectionViewCell, Xibable {
    var delegate: UpdateStatusDelegate?
    
    @IBOutlet var imageViewUser: UIImageView!
    
    @IBOutlet var labelUpdateStatus: UILabel!
    
    @IBAction func onButtonUpdateStatusClicked(_ sender: UIButton) {
        delegate?.onUpdateStatusClicked()
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
