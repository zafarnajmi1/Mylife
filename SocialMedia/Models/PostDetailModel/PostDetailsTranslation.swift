//
//	PostDetailsTranslation.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class PostDetailsTranslation : NSObject, NSCoding{

	var createdAt : Int!
	var feelingId : Int!
	var id : Int!
	var languageId : Int!
	var title : String!
	var updatedAt : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		createdAt = dictionary["created_at"] as? Int
		feelingId = dictionary["feeling_id"] as? Int
		id = dictionary["id"] as? Int
		languageId = dictionary["language_id"] as? Int
		title = dictionary["title"] as? String
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
		if feelingId != nil{
			dictionary["feeling_id"] = feelingId
		}
		if id != nil{
			dictionary["id"] = id
		}
		if languageId != nil{
			dictionary["language_id"] = languageId
		}
		if title != nil{
			dictionary["title"] = title
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
         feelingId = aDecoder.decodeObject(forKey: "feeling_id") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         languageId = aDecoder.decodeObject(forKey: "language_id") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String
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
		if feelingId != nil{
			aCoder.encode(feelingId, forKey: "feeling_id")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if languageId != nil{
			aCoder.encode(languageId, forKey: "language_id")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}

	}

}