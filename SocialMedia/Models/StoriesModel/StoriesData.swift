//
//  StoriesData.swift
//  SocialMedia
//
//  Created by Macbook on 19/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct StoriesData {
    
    var createdAt : Int!
    var id : Int!
    var snaps : [StoriesSnap]!
    var updatedAt : Int!
    var user : StoriesUser!
    var userId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        print(dictionary)
        
        createdAt = dictionary["created_at"] as? Int
        id = dictionary["id"] as? Int
        snaps = [StoriesSnap]()
        if let snapsArray = dictionary["snaps"] as? [[String:Any]]{
            for dic in snapsArray{
                let value = StoriesSnap(fromDictionary: dic)
                snaps.append(value)
            }
        }
        updatedAt = dictionary["updated_at"] as? Int
        if let userData = dictionary["user"] as? [String:Any]{
            user = StoriesUser(fromDictionary: userData)
        }
        userId = dictionary["user_id"] as? Int
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
        if snaps != nil{
            var dictionaryElements = [[String:Any]]()
            for snapsElement in snaps {
                dictionaryElements.append(snapsElement.toDictionary())
            }
            dictionary["snaps"] = dictionaryElements
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if user != nil{
            dictionary["user"] = user.toDictionary()
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
    
}
