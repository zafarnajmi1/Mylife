//
//  TimelinePostAttachment.swift
//  SocialMedia
//
//  Created by iOSDev on 10/25/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct TimelinePostAttachment{
    
    var createdAt : Int!
    var id : Int!
    var path : String!
    var postId : Int!
    var thumbnail : String!
    var type : String!
    var updatedAt : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? Int
        id = dictionary["id"] as? Int
        path = dictionary["path"] as? String
        postId = dictionary["post_id"] as? Int
        thumbnail = dictionary["thumbnail"] as? String
        type = dictionary["type"] as? String
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
        if id != nil{
            dictionary["id"] = id
        }
        if path != nil{
            dictionary["path"] = path
        }
        if postId != nil{
            dictionary["post_id"] = postId
        }
        if thumbnail != nil{
            dictionary["thumbnail"] = thumbnail
        }
        if type != nil{
            dictionary["type"] = type
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    
}
