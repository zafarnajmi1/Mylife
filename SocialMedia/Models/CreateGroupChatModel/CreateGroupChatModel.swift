//
//  CreateGroupChatModel.swift
//  SocialMedia
//
//  Created by Mughees Musaddiq on 19/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import Foundation

class CreateGroupChatModel : NSObject, NSCoding{
    
    var data : CreateGroupChatData!
//    var data : [CreateGroupChatData]!
    var message : String!
    var pagination : ChatPagination!
    var statusCode : Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
//        data = CreateGroupChatData()
        if let dataArray = dictionary["data"] as? [String:Any]{
            data = CreateGroupChatData(fromDictionary: dataArray)
//            for dic in dataArray{
//                let value = CreateGroupChatData(fromDictionary: dic)
//                data.append(value)
//            }
        }
        message = dictionary["message"] as? String
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = ChatPagination(fromDictionary: paginationData)
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
//            var dictionaryElements = [[String:Any]]()
//            for dataElement in data {
//                dictionaryElements.append(dataElement.toDictionary())
//            }
//            dictionary["data"] = dictionaryElements
            dictionary["data"] = data
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
    
    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
//        data = aDecoder.decodeObject(forKey :"data") as? [CreateGroupChatData]
        data = aDecoder.decodeObject(forKey :"data") as? CreateGroupChatData
        message = aDecoder.decodeObject(forKey: "message") as? String
        pagination = aDecoder.decodeObject(forKey: "pagination") as? ChatPagination
        statusCode = aDecoder.decodeObject(forKey: "status_code") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if data != nil{
            aCoder.encode(data, forKey: "data")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if pagination != nil{
            aCoder.encode(pagination, forKey: "pagination")
        }
        if statusCode != nil{
            aCoder.encode(statusCode, forKey: "status_code")
        }
        
    }

    
}
