//
//  SendMessageSender.swift
//  SocialMedia
//
//  Created by Macbook on 18/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct SendMessageSender{
    
    var fullName : String!
    var id : Int!
    var profilePicturePath : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        fullName = dictionary["full_name"] as? String
        id = dictionary["id"] as? Int
        profilePicturePath = dictionary["profile_picture_path"] as? String
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
        if profilePicturePath != nil{
            dictionary["profile_picture_path"] = profilePicturePath
        }
        return dictionary
    }
    
}
