//
//	searchPostFeeling.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class searchPostFeeling : NSObject, NSCoding{

	var createdAt : Int!
	var emoji : String!
	var id : Int!
	var translation : searchPostTranslation!
	var updatedAt : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		createdAt = dictionary["created_at"] as? Int
		emoji = dictionary["emoji"] as? String
		id = dictionary["id"] as? Int
		if let translationData = dictionary["translation"] as? [String:Any]{
			translation = searchPostTranslation(fromDictionary: translationData)
		}
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
		if emoji != nil{
			dictionary["emoji"] = emoji
		}
		if id != nil{
			dictionary["id"] = id
		}
		if translation != nil{
			dictionary["translation"] = translation.toDictionary()
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
         emoji = aDecoder.decodeObject(forKey: "emoji") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         translation = aDecoder.decodeObject(forKey: "translation") as? searchPostTranslation
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
		if emoji != nil{
			aCoder.encode(emoji, forKey: "emoji")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if translation != nil{
			aCoder.encode(translation, forKey: "translation")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}

	}

}