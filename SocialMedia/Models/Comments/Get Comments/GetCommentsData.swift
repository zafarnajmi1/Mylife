//
//	GetCommentsData.swift
//
//	Create by Apple PC on 5/10/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class GetCommentsData : NSObject, NSCoding{

	var attachment : String!
    var get_sub_comments_count : Int!
	var comment : String!
	var createdAt : Int!
	var id : Int!
	var postId : Int!
	var updatedAt : Int!
	var user : GetCommentsUser!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){        
		attachment = dictionary["attachment"] as? String
        get_sub_comments_count = dictionary["get_sub_comments_count"] as? Int
		comment = dictionary["comment"] as? String
		createdAt = dictionary["created_at"] as? Int
		id = dictionary["id"] as? Int
		postId = dictionary["post_id"] as? Int
		updatedAt = dictionary["updated_at"] as? Int
		if let userData = dictionary["user"] as? [String:Any]{
			user = GetCommentsUser(fromDictionary: userData)
		}
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
        if get_sub_comments_count != nil{
            dictionary["get_sub_comments_count"] = get_sub_comments_count
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
         attachment = aDecoder.decodeObject(forKey: "attachment") as? String
        get_sub_comments_count = aDecoder.decodeObject(forKey: "get_sub_comments_count") as? Int

         comment = aDecoder.decodeObject(forKey: "comment") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         postId = aDecoder.decodeObject(forKey: "post_id") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int
         user = aDecoder.decodeObject(forKey: "user") as? GetCommentsUser
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
        
        if get_sub_comments_count != nil{
            aCoder.encode(get_sub_comments_count, forKey: "get_sub_comments_count")
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
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}
