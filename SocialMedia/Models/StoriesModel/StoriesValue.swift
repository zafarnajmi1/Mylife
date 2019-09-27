//
//  StoriesValue.swift
//  SocialMedia
//
//  Created by Macbook on 19/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct StoriesValue{
    
    var filterId : Int!
    var type : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        filterId = dictionary["filter_id"] as? Int
        type = dictionary["type"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if filterId != nil{
            dictionary["filter_id"] = filterId
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
    
}
