//
//  FeelingsTranslation.swift
//  SocialMedia
//
//  Created by iOSDev on 10/26/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct FeelingsTranslation{
    
    var createdAt : Int!
    var feelingId : Int!
    var id : Int!
    var languageId : Int!
    var title : String!
    var updatedAt : Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? Int
        feelingId = dictionary["feeling_id"] as? Int
        id = dictionary["id"] as? Int
        languageId = dictionary["language_id"] as? Int
        title = dictionary["title"] as? String
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
        if feelingId != nil{
            dictionary["feeling_id"] = feelingId
        }
        if id != nil{
            dictionary["id"] = id
        }
        if languageId != nil{
            dictionary["language_id"] = languageId
        }
        if title != nil{
            dictionary["title"] = title
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    
}
