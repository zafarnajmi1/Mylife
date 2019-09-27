//
//  Profile.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 17/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import IGListKit

protocol ProfileAtributes {
    var id: Int {get set}
    var postId: Int {get set}
    var name: String {get set}
    var firstName: String? {get set}
    var lastName: String? {get set}
    var image: String {get set}
    var banner: String {get set}
    var city: String {get set}
    var country: String {get set}
}

extension Post {
    var isSelfProfile: Bool { return self is isSelfProfile }
    var isOtherProfile: Bool { return self is isOtherProfile }
}

protocol isSelfProfile { }
protocol isOtherProfile { }

extension Profile: Equatable {
    static public func ==(rhs: Profile, lhs: Profile) -> Bool {
        return lhs.id == rhs.id
    }
}

class Profile: ProfileAtributes, ListDiffable {
    var id: Int = 0
    var postId: Int = 0
    var name: String = ""
    var firstName: String? = ""
    var lastName: String? = ""
    var image: String = ""
    var banner: String = ""
    var city: String = ""
    var country: String = ""
   
    init() {
        
    }
    
    init(id: Int, name: String, firstName: String?, lastName: String?, image: String, banner: String, city: String, country: String) {
        self.id = id
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.image = image
        self.banner = banner
        self.city = city
        self.country = country
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSNumber(value: id)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Profile else {
            return false
        }
        
        if id != object.id {
            return false
        }
        
        return self == object
    }
}

class SelfProfile: Profile, isSelfProfile {
    
}

class OtherProfile: Profile, isOtherProfile {
    
}


