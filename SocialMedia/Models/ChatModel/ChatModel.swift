//
//  ChatModel.swift
//  SocialMedia
//
//  Created by Macbook on 17/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct ChatModel{
    
    var data : [ChatData]!
    var data_new_message : ChatData?
    var message : String!
    var pagination : ChatPagination!
    var groupDetail : GroupDetail!
    var statusCode : Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        data = [ChatData]()
        if let dataArray = dictionary["data"] as? [[String:Any]]{
            for dic in dataArray{
                let value = ChatData(fromDictionary: dic)
                data.append(value)
            }
        }
        
        if let _group_detail = dictionary["group_detail"] as? [String:Any]{
            groupDetail = GroupDetail(fromDictionary: _group_detail)
        }

        
        message = dictionary["message"] as? String
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = ChatPagination(fromDictionary: paginationData)
        }
        statusCode = dictionary["status_code"] as? Int
        
        if let senderData = dictionary["data"] as? [String:Any]{
            data_new_message = ChatData(fromDictionary: senderData)
        }
        
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
        
        if data_new_message != nil{
            dictionary["data"] = data_new_message?.toDictionary()
        }
        
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }
        if statusCode != nil{
            dictionary["status_code"] = statusCode
        }
        if groupDetail != nil{
            dictionary["group_detail"] = groupDetail.toDictionary()
        }

        return dictionary
    }
    
}
