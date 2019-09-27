//
//	PostDetailsPivot.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class PostDetailsPivot : NSObject, NSCoding{

	var postId : Int!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		postId = dictionary["post_id"] as? Int
		userId = dictionary["user_id"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if postId != nil{
			dictionary["post_id"] = postId
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
         postId = aDecoder.decodeObject(forKey: "post_id") as? Int
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if postId != nil{
			aCoder.encode(postId, forKey: "post_id")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}