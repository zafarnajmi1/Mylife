//
//	MyNotificationsData.swift
//
//	Create by Apple PC on 16/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class MyNotificationsData : NSObject, NSCoding{

	var createdAt : Int!
	var descriptionField : String!
	var extra : Int!
	var id : Int!
	var isRead : Bool!
	var senderId : Int!
	var title : String!
	var type : String!
	var updatedAt : Int!
	var user : MyNotificationsUser!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		createdAt = dictionary["created_at"] as? Int
		descriptionField = dictionary["description"] as? String
		extra = dictionary["extra"] as? Int
		id = dictionary["id"] as? Int
		isRead = dictionary["is_read"] as? Bool
		senderId = dictionary["sender_id"] as? Int
		title = dictionary["title"] as? String
		type = dictionary["type"] as? String
		updatedAt = dictionary["updated_at"] as? Int
		if let userData = dictionary["user"] as? [String:Any]{
			user = MyNotificationsUser(fromDictionary: userData)
		}
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
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if extra != nil{
			dictionary["extra"] = extra
		}
		if id != nil{
			dictionary["id"] = id
		}
		if isRead != nil{
			dictionary["is_read"] = isRead
		}
		if senderId != nil{
			dictionary["sender_id"] = senderId
		}
		if title != nil{
			dictionary["title"] = title
		}
		if type != nil{
			dictionary["type"] = type
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if user != nil{
			dictionary["user"] = user.toDictionary()
		}
		if userId != nil{
			dictionary["user_id"] = userId
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         extra = aDecoder.decodeObject(forKey: "extra") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         isRead = aDecoder.decodeObject(forKey: "is_read") as? Bool
         senderId = aDecoder.decodeObject(forKey: "sender_id") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int
         user = aDecoder.decodeObject(forKey: "user") as? MyNotificationsUser
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if extra != nil{
			aCoder.encode(extra, forKey: "extra")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if isRead != nil{
			aCoder.encode(isRead, forKey: "is_read")
		}
		if senderId != nil{
			aCoder.encode(senderId, forKey: "sender_id")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}
