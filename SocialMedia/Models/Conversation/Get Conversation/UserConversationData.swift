//
//	UserConversationData.swift
//
//	Create by Apple PC on 4/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class UserConversationData : NSObject, NSCoding{

	var attachment : String!
	var attachmentType : String!
	var conversationId : Int!
	var createdAt : Int!
	var deletedBy : String!
	var id : Int!
	var isRead : Bool!
	var message : String!
	var receiver_id : Int!
	var senderId : Int!
	var updatedAt : Int!
    var user : UserConversationUser!
    var chatGroup : UserConversationChatGroup!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		attachment = dictionary["attachment"] as? String
		attachmentType = dictionary["attachment_type"] as? String
		conversationId = dictionary["conversation_id"] as? Int
		createdAt = dictionary["created_at"] as? Int
		deletedBy = dictionary["deleted_by"] as? String
		id = dictionary["id"] as? Int
		isRead = dictionary["is_read"] as? Bool
		message = dictionary["message"] as? String
		receiver_id = dictionary["receiver_id"] as? Int
		senderId = dictionary["sender_id"] as? Int
		updatedAt = dictionary["updated_at"] as? Int
		if let userData = dictionary["user"] as? [String:Any]{
			user = UserConversationUser(fromDictionary: userData)
		}
        if let _chatGroup = dictionary["chat_group"] as? [String:Any]{
            chatGroup = UserConversationChatGroup(fromDictionary: _chatGroup)
        }
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
		if attachmentType != nil{
			dictionary["attachment_type"] = attachmentType
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
		if receiver_id != nil{
			dictionary["receiver_id"] = receiver_id
		}
		if senderId != nil{
			dictionary["sender_id"] = senderId
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if user != nil{
			dictionary["user"] = user.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         attachment = aDecoder.decodeObject(forKey: "attachment") as? String
         attachmentType = aDecoder.decodeObject(forKey: "attachment_type") as? String
         conversationId = aDecoder.decodeObject(forKey: "conversation_id") as? Int
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         deletedBy = aDecoder.decodeObject(forKey: "deleted_by") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         isRead = aDecoder.decodeObject(forKey: "is_read") as? Bool
         message = aDecoder.decodeObject(forKey: "message") as? String
         receiver_id = aDecoder.decodeObject(forKey: "receiver_id") as? Int
         senderId = aDecoder.decodeObject(forKey: "sender_id") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int
         user = aDecoder.decodeObject(forKey: "user") as? UserConversationUser

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if attachment != nil{
			aCoder.encode(attachment, forKey: "attachment")
		}
		if attachmentType != nil{
			aCoder.encode(attachmentType, forKey: "attachment_type")
		}
		if conversationId != nil{
			aCoder.encode(conversationId, forKey: "conversation_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if deletedBy != nil{
			aCoder.encode(deletedBy, forKey: "deleted_by")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if isRead != nil{
			aCoder.encode(isRead, forKey: "is_read")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if receiver_id != nil{
			aCoder.encode(receiver_id, forKey: "receiver_id")
		}
		if senderId != nil{
			aCoder.encode(senderId, forKey: "sender_id")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}

	}

}
