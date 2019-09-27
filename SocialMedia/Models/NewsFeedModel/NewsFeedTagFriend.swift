//
//  NewsFeedTagFriend.swift
//  SocialMedia
//
//  Created by iOSDev on 11/10/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct NewsFeedTagFriend{
    
    var fullName : String!
    var id : Int!
    var image : String!
    var pivot : NewsFeedPivot!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        fullName = dictionary["full_name"] as? String
        id = dictionary["id"] as? Int
        image = dictionary["image"] as? String
        if let pivotData = dictionary["pivot"] as? [String:Any]{
            pivot = NewsFeedPivot(fromDictionary: pivotData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if fullName != nil{
            dictionary["full_name"] = fullName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if pivot != nil{
            dictionary["pivot"] = pivot.toDictionary()
        }
        return dictionary
    }
    
}
