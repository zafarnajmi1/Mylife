//
//  NewsFeedPivot.swift
//  SocialMedia
//
//  Created by iOSDev on 11/10/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct NewsFeedPivot{
    
    var postId : Int!
    var userId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        postId = dictionary["post_id"] as? Int
        userId = dictionary["user_id"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if postId != nil{
            dictionary["post_id"] = postId
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
    
}
