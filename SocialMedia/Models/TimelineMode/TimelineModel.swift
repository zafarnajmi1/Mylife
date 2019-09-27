//
//  TimelineModel.swift
//  SocialMedia
//
//  Created by iOSDev on 10/25/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct TimelineModel{
    
    var data : [TimelineData]!
    var message : String!
    var pagination : TimelinePagination!
    var statusCode : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        data = [TimelineData]()
        if let dataArray = dictionary["data"] as? [[String:Any]]{
            for dic in dataArray{
                let value = TimelineData(fromDictionary: dic)
                data.append(value)
            }
        }
        message = dictionary["message"] as? String
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = TimelinePagination(fromDictionary: paginationData)
        }
        statusCode = dictionary["status_code"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            var dictionaryElements = [[String:Any]]()
            for dataElement in data {
                dictionaryElements.append(dataElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
        }
        if message != nil{
            dictionary["message"] = message
        }
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }
        if statusCode != nil{
            dictionary["status_code"] = statusCode
        }
        return dictionary
    }
    
}
