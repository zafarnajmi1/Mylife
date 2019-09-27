//
//  ChatData.swift
//  SocialMedia
//
//  Created by Macbook on 17/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

public class ChatData{
    
    var attachment : String!
    var attachment_type : String!
    var conversationId : Int!
    var createdAt : Int!
    var deletedBy : Int!
    var id : Int!
    var isRead : Bool!
    var message : String!
    var receiverId : Int!
    var sender : ChatSender!
    var senderId : Int!
    var updatedAt : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        attachment = dictionary["attachment"] as? String
        attachment_type = dictionary["attachment_type"] as? String
        conversationId = dictionary["conversation_id"] as? Int
        createdAt = dictionary["created_at"] as? Int
        deletedBy = dictionary["deleted_by"] as? Int
        id = dictionary["id"] as? Int
        isRead = dictionary["is_read"] as? Bool
        message = dictionary["message"] as? String
        receiverId = dictionary["receiver_id"] as? Int
        if let senderData = dictionary["sender"] as? [String:Any]{
            sender = ChatSender(fromDictionary: senderData)
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
        if attachment_type != nil{
            dictionary["attachment_type"] = attachment_type
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

struct  GroupDetail {
    
//    "created_at" = 1516822863;
//    groupMembers =         (
//    {
//    "full_name" = "Manzoor Ahmed Bajwa";
//    id = 6;
//    image = "http://mytechnology.ae/test/my-life/live/uploads/image/mylifeprofile-1516023191.jpg";
//    },
//    {
//    "full_name" = "Manzoor Ahmed Bajwa";
//    id = 13;
//    image = "http://mytechnology.ae/test/my-life/live/uploads/profile_pictures/default-photo.jpg";
//    },
//    {
//    "full_name" = "Maria catel";
//    id = 46;
//    image = "http://mytechnology.ae/test/my-life/live/uploads/profile_pictures/1516023106.jpg";
//    }
//    );
//    id = 68;
//    image = "http://mytechnology.ae/test/my-life/live/assets/default/default_group_image.jpg";
//    "owner_id" = 46;
//    privacy = "members_only";
//    title = tes;
//    "updated_at" = 1516822863;
    
    var created_at : Int!
    var id : Int!
    var image : String!
    var owner_id : Int!
    var privacy : String!
    var title : String!
    var updated_at : Int!
    var groupMembers : [GroupMember]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        created_at = dictionary["created_at"] as? Int
        id = dictionary["id"] as? Int
        image = dictionary["image"] as? String
        owner_id = dictionary["owner_id"] as? Int
        privacy = dictionary["privacy"] as? String
        title = dictionary["title"] as? String
        if let _groupMembers = dictionary["groupMembers"] as? [[String:Any]] {
            groupMembers = []
            for object in _groupMembers {
                let memeber = GroupMember(fromDictionary: object)
                groupMembers.append(memeber)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if created_at != nil{
            dictionary["created_at"] = created_at
        }
        if image != nil{
            dictionary["image"] = image
        }
        if id != nil{
            dictionary["id"] = id
        }
        if owner_id != nil{
            dictionary["owner_id"] = owner_id
        }
        if privacy != nil{
            dictionary["privacy"] = privacy
        }
        if title != nil{
            dictionary["title"] = title
        }
        if groupMembers != nil{
            dictionary["groupMembers"] = groupMembers
        }
        
        return dictionary
    }
    
}

struct  GroupMember {
    
    
    var id : Int!
    var image : String!
    var full_name : String!
    var is_online: Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        is_online = dictionary["is_online"] as? Int
        id = dictionary["id"] as? Int

        image = dictionary["image"] as? String
        full_name = dictionary["full_name"] as? String
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if image != nil{
            dictionary["image"] = image
        }
        if is_online != nil{
            dictionary["is_online"] = is_online
        }
        if id != nil{
            dictionary["id"] = id
        }
        if full_name != nil{
            dictionary["full_name"] = full_name
        }
        
        return dictionary
    }
    
}

