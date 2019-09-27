//
//	PostDetailsTagFriend.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class PostDetailsTagFriend : NSObject, NSCoding{

	var fullName : String!
	var id : Int!
	var image : String!
	var pivot : PostDetailsPivot!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		fullName = dictionary["full_name"] as? String
		id = dictionary["id"] as? Int
		image = dictionary["image"] as? String
		if let pivotData = dictionary["pivot"] as? [String:Any]{
			pivot = PostDetailsPivot(fromDictionary: pivotData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if fullName != nil{
			dictionary["full_name"] = fullName
		}
		if id != nil{
			dictionary["id"] = id
		}
		if image != nil{
			dictionary["image"] = image
		}
		if pivot != nil{
			dictionary["pivot"] = pivot.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         fullName = aDecoder.decodeObject(forKey: "full_name") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         image = aDecoder.decodeObject(forKey: "image") as? String
         pivot = aDecoder.decodeObject(forKey: "pivot") as? PostDetailsPivot

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if fullName != nil{
			aCoder.encode(fullName, forKey: "full_name")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if pivot != nil{
			aCoder.encode(pivot, forKey: "pivot")
		}

	}

}