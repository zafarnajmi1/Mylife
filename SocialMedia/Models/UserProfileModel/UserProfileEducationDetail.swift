//
//  UserProfileEducationDetail.swift
//  SocialMedia
//
//  Created by iOSDev on 11/1/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct UserProfileEducationDetail{
    
    var createdAt : Int!
    var dateFrom : Int!
    var dateTo : Int!
    var degree : String!
    var id : Int!
    var school : String!
    var updatedAt : Int!
    var userId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? Int
        dateFrom = dictionary["date_from"] as? Int
        dateTo = dictionary["date_to"] as? Int
        degree = dictionary["degree"] as? String
        id = dictionary["id"] as? Int
        school = dictionary["school"] as? String
        updatedAt = dictionary["updated_at"] as? Int
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
        if dateFrom != nil{
            dictionary["date_from"] = dateFrom
        }
        if dateTo != nil{
            dictionary["date_to"] = dateTo
        }
        if degree != nil{
            dictionary["degree"] = degree
        }
        if id != nil{
            dictionary["id"] = id
        }
        if school != nil{
            dictionary["school"] = school
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
    
}
