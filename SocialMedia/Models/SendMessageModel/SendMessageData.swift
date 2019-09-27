//
//  SendMessageData.swift
//  SocialMedia
//
//  Created by Macbook on 18/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

struct SendMessageData{
    
    var attachment : String!
    var conversationId : Int!
    var createdAt : Int!
    var deletedBy : Int!
    var id : Int!
    var isRead : Bool!
    var message : String!
    var receiverId : Int!
    var sender : SendMessageSender!
    var senderId : Int!
    var updatedAt : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        attachment = dictionary["attachment"] as? String
        conversationId = dictionary["conversation_id"] as? Int
        createdAt = dictionary["created_at"] as? Int
        deletedBy = dictionary["deleted_by"] as? Int
        id = dictionary["id"] as? Int
        isRead = dictionary["is_read"] as? Bool
        message = dictionary["message"] as? String
        receiverId = dictionary["receiver_id"] as? Int
        if let senderData = dictionary["sender"] as? [String:Any]{
            sender = SendMessageSender(fromDictionary: senderData)
        }
        senderId = dictionary["sender_id"] as? Int
        updatedAt = dictionary["updated_at"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if attachment != nil{
            dictionary["attachment"] = attachment
        }
        if conversationId != nil{
            dictionary["conversation_id"] = conversationId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if deletedBy != nil{
            dictionary["deleted_by"] = deletedBy
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isRead != nil{
            dictionary["is_read"] = isRead
        }
        if message != nil{
            dictionary["message"] = message
        }
        if receiverId != nil{
            dictionary["receiver_id"] = receiverId
        }
        if sender != nil{
            dictionary["sender"] = sender.toDictionary()
        }
        if senderId != nil{
            dictionary["sender_id"] = senderId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    
}
