//
//  NSObject+IGListDiffable.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 18/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

import IGListKit

//// MARK: - IGListDiffable
extension NSObject: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}
