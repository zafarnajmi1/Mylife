//
//  UserProfileWorkDetail.swift
//  SocialMedia
//
//  Created by iOSDev on 11/1/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct UserProfileWorkDetail{
    
    var city : String!
    var company : String!
    var createdAt : Int!
    var dateFrom : Int!
    var dateTo : Int!
    var descriptionField : String!
    var id : Int!
    var position : String!
    var updatedAt : Int!
    var userId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        city = dictionary["city"] as? String
        company = dictionary["company"] as? String
        createdAt = dictionary["created_at"] as? Int
        dateFrom = dictionary["date_from"] as? Int
        dateTo = dictionary["date_to"] as? Int
        descriptionField = dictionary["description"] as? String
        id = dictionary["id"] as? Int
        position = dictionary["position"] as? String
        updatedAt = dictionary["updated_at"] as? Int
        userId = dictionary["user_id"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if city != nil{
            dictionary["city"] = city
        }
        if company != nil{
            dictionary["company"] = company
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if dateFrom != nil{
            dictionary["date_from"] = dateFrom
        }
        if dateTo != nil{
            dictionary["date_to"] = dateTo
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if id != nil{
            dictionary["id"] = id
        }
        if position != nil{
            dictionary["position"] = position
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
