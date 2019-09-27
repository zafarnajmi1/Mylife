//
//  TimelinePagination.swift
//  SocialMedia
//
//  Created by iOSDev on 10/25/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct TimelinePagination{
    
    var currentPage : Int!
    var from : Int!
    var lastPage : Int!
    var nextPageUrl : AnyObject!
    var path : String!
    var perPage : String!
    var prevPageUrl : AnyObject!
    var to : Int!
    var total : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        currentPage = dictionary["current_page"] as? Int
        from = dictionary["from"] as? Int
        lastPage = dictionary["last_page"] as? Int
        nextPageUrl = dictionary["next_page_url"] as? AnyObject
        path = dictionary["path"] as? String
        perPage = dictionary["per_page"] as? String
        prevPageUrl = dictionary["prev_page_url"] as? AnyObject
        to = dictionary["to"] as? Int
        total = dictionary["total"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if currentPage != nil{
            dictionary["current_page"] = currentPage
        }
        if from != nil{
            dictionary["from"] = from
        }
        if lastPage != nil{
            dictionary["last_page"] = lastPage
        }
        if nextPageUrl != nil{
            dictionary["next_page_url"] = nextPageUrl
        }
        if path != nil{
            dictionary["path"] = path
        }
        if perPage != nil{
            dictionary["per_page"] = perPage
        }
        if prevPageUrl != nil{
            dictionary["prev_page_url"] = prevPageUrl
        }
        if to != nil{
            dictionary["to"] = to
        }
        if total != nil{
            dictionary["total"] = total
        }
        return dictionary
    }
    
}
