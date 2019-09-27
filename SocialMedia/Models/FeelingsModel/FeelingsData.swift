//
//  FeelingsData.swift
//  SocialMedia
//
//  Created by iOSDev on 10/26/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct FeelingsData{
    
    var createdAt : Int!
    var emoji : String!
    var id : Int!
    var translation : FeelingsTranslation!
    var updatedAt : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? Int
        emoji = dictionary["emoji"] as? String
        id = dictionary["id"] as? Int
        if let translationData = dictionary["translation"] as? [String:Any]{
            translation = FeelingsTranslation(fromDictionary: translationData)
        }
        updatedAt = dictionary["updated_at"] as? Int
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
        if emoji != nil{
            dictionary["emoji"] = emoji
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
