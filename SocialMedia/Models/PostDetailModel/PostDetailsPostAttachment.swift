//
//	PostDetailsPostAttachment.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class PostDetailsPostAttachment : NSObject, NSCoding{

	var createdAt : Int!
	var id : Int!
	var path : String!
	var postId : Int!
	var thumbnail : String!
	var type : String!
	var updatedAt : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		createdAt = dictionary["created_at"] as? Int
		id = dictionary["id"] as? Int
		path = dictionary["path"] as? String
		postId = dictionary["post_id"] as? Int
		thumbnail = dictionary["thumbnail"] as? String
		type = dictionary["type"] as? String
		updatedAt = dictionary["updated_at"] as? Int
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
		if id != nil{
			dictionary["id"] = id
		}
		if path != nil{
			dictionary["path"] = path
		}
		if postId != nil{
			dictionary["post_id"] = postId
		}
		if thumbnail != nil{
			dictionary["thumbnail"] = thumbnail
		}
		if type != nil{
			dictionary["type"] = type
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
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
         id = aDecoder.decodeObject(forKey: "id") as? Int
         path = aDecoder.decodeObject(forKey: "path") as? String
         postId = aDecoder.decodeObject(forKey: "post_id") as? Int
         thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int

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
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if path != nil{
			aCoder.encode(path, forKey: "path")
		}
		if postId != nil{
			aCoder.encode(postId, forKey: "post_id")
		}
		if thumbnail != nil{
			aCoder.encode(thumbnail, forKey: "thumbnail")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}

	}

}