//
//  FaqsData.swift
//  SocialMedia
//
//  Created by iOSDev on 11/3/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct FaqsData{
    
    var createdAt : Int!
    var id : Int!
    var isOpen : Bool!
    var translation : FaqsTranslation!
    var updatedAt : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? Int
        id = dictionary["id"] as? Int
        if let translationData = dictionary["translation"] as? [String:Any]{
            translation = FaqsTranslation(fromDictionary: translationData)
        }
        updatedAt = dictionary["updated_at"] as? Int
        isOpen = false
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if translation != nil{
            dictionary["translation"] = translation.toDictionary()
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    
}
