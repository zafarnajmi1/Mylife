//
//	PostCommentsData.swift
//
//	Create by Apple PC on 18/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class PostCommentsData : NSObject, NSCoding{

	var attachment : String!
	var comment : String!
	var createdAt : Int!
	var id : Int!
	var postId : Int!
	var updatedAt : Int!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		attachment = dictionary["attachment"] as? String
		comment = dictionary["comment"] as? String
		createdAt = dictionary["created_at"] as? Int
		id = dictionary["id"] as? Int
		postId = dictionary["post_id"] as? Int
		updatedAt = dictionary["updated_at"] as? Int
		userId = dictionary["user_id"] as? Int
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
		if comment != nil{
			dictionary["comment"] = comment
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if id != nil{
			dictionary["id"] = id
		}
		if postId != nil{
			dictionary["post_id"] = postId
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
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
         attachment = aDecoder.decodeObject(forKey: "attachment") as? String
         comment = aDecoder.decodeObject(forKey: "comment") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         postId = aDecoder.decodeObject(forKey: "post_id") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int

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
		if comment != nil{
			aCoder.encode(comment, forKey: "comment")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if postId != nil{
			aCoder.encode(postId, forKey: "post_id")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}