//
//  StoriesSnap.swift
//  SocialMedia
//
//  Created by Macbook on 19/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct StoriesSnap{
    
    var createdAt : Int!
    var id : Int!
    var media : String!
    var overlay : String!
    var thumbnail : String!
    var type : String!
    var storyId : Int!
    var updatedAt : Int!
    var values : StoriesValue!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? Int
        id = dictionary["id"] as? Int
        media = dictionary["media"] as? String
        overlay = dictionary["overlay"] as? String
        type = dictionary["type"] as? String
        thumbnail = dictionary["thumbnail"] as? String

        storyId = dictionary["story_id"] as? Int
        updatedAt = dictionary["updated_at"] as? Int
        if let valuesData = dictionary["values"] as? [String:Any]{
            values = StoriesValue(fromDictionary: valuesData)
        }
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
        if media != nil{
            dictionary["media"] = media
        }
        if overlay != nil{
            dictionary["overlay"] = overlay
        }
        if type != nil{
            dictionary["type"] = type
        }
        
        if thumbnail != nil{
            dictionary["thumbnail"] = thumbnail
        }
        if storyId != nil{
            dictionary["story_id"] = storyId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if values != nil{
            dictionary["values"] = values.toDictionary()
        }
        return dictionary
    }
    
}
