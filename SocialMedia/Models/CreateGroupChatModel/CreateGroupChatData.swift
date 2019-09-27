//
//  CreateGroupChatData.swift
//  SocialMedia
//
//  Created by Mughees Musaddiq on 19/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import Foundation

struct CreateGroupChatData{
    
//    {"message":"Chat Group Updated","data":{"id":15,"title":"New Group","owner_id":4,"created_at":1509954681,"updated_at":1509954681,"deleted_at":null},"status_code":200,"pagination":{}}
    
    var title : String!
    var ownerId : Int!
    var createdAt : Int!
    var deletedAt : Int!
    var id : Int!
    var updatedAt : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        title = dictionary["title"] as? String
        ownerId = dictionary["owner_id"] as? Int
        createdAt = dictionary["created_at"] as? Int
        deletedAt = dictionary["deleted_at"] as? Int
        id = dictionary["id"] as? Int
        updatedAt = dictionary["updated_at"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if title != nil{
            dictionary["title"] = title
        }
        if ownerId != nil{
            dictionary["owner_id"] = ownerId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
}
